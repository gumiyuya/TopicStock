class TopicsController < ApplicationController
  before_action :ensure_correct_user_by_user_id

  def stock
    @topic = Topic.find_by(id: params[:topic_id])
    if @topic
      @connections = Connection.where(topic_id: @topic.id)
    else
      topics = Topic.where(user_id: 1)
      @topic = topics[rand(topics.size)]
      @connections = Connection.where(topic_id: @topic.id)
    end
  end

  # アクセス制限
  def ensure_correct_user_by_user_id
    if @current_user
      session[:user_id] = nil
      redirect_to("/")
    end
  end

end
