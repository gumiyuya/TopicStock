class SearchesController < ApplicationController

  def search
    @keyword = params[:keyword]
    @topics = Topic.where(
      "content LIKE? AND user_id = ?",
      "%#{@keyword}%", @current_user.id
    )
    if @topics.count == 0
      @error_message = "トピックが見つかりませんでした"
    end
  end

end
