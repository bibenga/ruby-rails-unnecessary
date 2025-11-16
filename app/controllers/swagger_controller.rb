class SwaggerController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]

  def index
    render layout: false
  end
end
