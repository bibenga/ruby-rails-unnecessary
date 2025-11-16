class Job1Job < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "OLALA: #{args}"
    logger.info "OLALA: #{args}"
  end
end
