require "active_storage/service"
require "pg"

class ActiveStorage::Service::LobService < ActiveStorage::Service
  CHUNK_SIZE = 65536
  # CHUNK_SIZE = 2048

  MODE_WRITE = 0x20000
  MODE_READ = 0x40000
  MODE_READWRITE = MODE_READ | MODE_WRITE

  SEEK_SET = 0
  SEEK_CUR = 1
  SEEK_END = 2

  def upload(key, io, checksum: nil, **options)
    ActiveRecord::Base.transaction do
      conn = ActiveRecord::Base.connection.raw_connection

      loid = conn.lo_creat(0)

      fd = conn.lo_open(loid, PG::Constants::INV_WRITE)
      raise StandardError if fd < 0

      io.rewind
      while (chunk = io.read(CHUNK_SIZE))
        conn.lowrite(fd, chunk)
      end

      conn.lo_close(fd)

      # we store loid in the metadata
      sql = ActiveRecord::Base.sanitize_sql_array([
        "metadata = jsonb_set(metadata::jsonb, '{loid}', to_jsonb(?))::text",
        loid
      ])
      ActiveStorage::Blob.where(key: key).update_all(sql)
    end
  end

  def download(key)
    ActiveRecord::Base.transaction do
      # retrive loid from the metadata
      loid = ActiveStorage::Blob.where(key: key).pluck(Arel.sql("(metadata::jsonb->'loid')::bigint"))[0]
      raise StandardError if loid.nil?

      conn = ActiveRecord::Base.connection.raw_connection

      fd = conn.lo_open(loid, PG::Constants::INV_READ)
      raise StandardError if fd < 0

      if block_given?
        loop do
          chunk = conn.loread(fd, CHUNK_SIZE)
          break if chunk.nil?
          yield chunk
        end
        conn.lo_close(fd)
      else
        buf = "".b
        loop do
          chunk = conn.loread(fd, CHUNK_SIZE)
          break if chunk.nil?
          buf += chunk.b
        end
        conn.lo_close(fd)
        buf
      end
    end
  end

  def delete(key)
    # retrive loid from the metadata
    loid = ActiveStorage::Blob.where(key: key).pluck(Arel.sql("(metadata::jsonb->'loid')::bigint"))[0]
    raise StandardError if loid.nil?
    ActiveRecord::Base.connection.exec_query("select lo_unlink($1)", "SQL", [ loid ])
  end

  def exist?(key)
    # retrive loid from the metadata
    loid = ActiveStorage::Blob.where(key: key).pluck(Arel.sql("(metadata::jsonb->'loid')::bigint"))[0]
    raise StandardError if loid.nil?
    row = ActiveRecord::Base.connection.select_one(
      "select exists(select loid from pg_largeobject_metadata where loid=$1) as e",
      "SQL", [ loid ]
    )
    row["e"]
  end
end
