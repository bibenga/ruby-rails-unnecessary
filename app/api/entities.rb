# module Api
module Entities
  class Status < Grape::Entity
    expose :message, documentation: { type: String, desc: "System status" }
    expose :user, documentation: { type: Integer, desc: "Current user", required: false }
  end

  # class Error < Grape::Entity
  #   expose :code
  #   expose :message
  # end
end
# end
