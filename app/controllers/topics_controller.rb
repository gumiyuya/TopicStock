class TopicsController < ApplicationController
  
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

end
