class ApplicationController < ActionController::Base
  before_action :set_current_user
  before_action :check_existence_of_topic

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def check_existence_of_topic
    if @current_user
      @existing_topic = Topic.find_by(user_id: @current_user.id)
    end
  end
end
