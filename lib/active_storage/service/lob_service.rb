require "active_storage/service"

class ActiveStorage::Service::LobService < ActiveStorage::Service
  CHUNK_SIZE = 65536

  MODE_WRITE = 0x20000
  MODE_READ = 0x40000
  MODE_READWRITE = MODE_READ | MODE_WRITE

  SEEK_SET = 0
  SEEK_CUR = 1
  SEEK_END = 2

  def upload(key, io, checksum: nil, **options)
    ActiveRecord::Base.transaction do
      row  = ActiveRecord::Base.connection.select_one("select lo_create(0) as loid")
      loid = row["loid"].to_i

      row = ActiveRecord::Base.connection.select_one("select lo_open($1, $2) as fd", "SQL", [ loid, MODE_WRITE ])
      fd = row["fd"].to_i
      raise StandardError if fd == 0

      io.rewind
      while (chunk = io.read(CHUNK_SIZE))
        chunk = ActiveRecord::Base.connection.escape_bytea(chunk)
        ActiveRecord::Base.connection.exec_query("select lowrite($1, $2)", "SQL", [ fd, chunk ])
      end

      ActiveRecord::Base.connection.exec_query("select lo_close($1)", "SQL", [ fd ])

      blob = ActiveStorage::Blob.find_by!(key: key)
      blob.update_column(:metadata, blob.metadata.merge("loid" => loid))
    end
  end

  def download(key)
    puts "OLALA: #{block_given?}"

    blob = ActiveStorage::Blob.find_by!(key: key)
    loid = blob.metadata["loid"].to_i
    pp loid
    row = ActiveRecord::Base.connection.select_one("select lo_open($1, $2) as fd", "SQL", [ loid, MODE_READ ])
    pp row
    fd = row["fd"].to_i
    raise StandardError if fd == 0
    begin
      if block_given?
        loop do
          row = ActiveRecord::Base.connection.select_one("select loread($1, $2) as c", "SQL", [ fd, CHUNK_SIZE ])
          chunk = row["c"]
          break if chunk.empry?
          yield chunk
        end
      else
        buf = ""
        loop do
          row = ActiveRecord::Base.connection.select_one("select loread($1, $2) as c", "SQL", [ fd, CHUNK_SIZE ])
          chunk = row["c"]
          break if chunk.empry?
          buf += chunk
        end
        pp buf
        buf
      end
    ensure
      ActiveRecord::Base.connection.exec_query("select lo_close($1)", "SQL", [ fd ])
    end
  end

  def delete(key)
    blob = ActiveStorage::Blob.find_by!(key: key)
    loid = blob.metadata["loid"].to_i
    ActiveRecord::Base.connection.exec_query("select lo_unlink($1)", "SQL", [ loid ])
  end

  def exist?(key)
    blob = ActiveStorage::Blob.find_by!(key: key)
    loid = blob.metadata["loid"].to_i
    row = ActiveRecord::Base.connection.select_one("select exists(select loid from pg_largeobject_metadata where loid=$1) as e", "SQL", [ loid ])
    row["e"]
  end
end
