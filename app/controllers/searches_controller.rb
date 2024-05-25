class SearchesController < ApplicationController

  def search
    # 空白で区切りand検索できるようにする
    keywords = params[:keyword].split(/[[:blank:]]+/)
    @topics = Topic.all
    keywords.each do |keyword|
      next if keyword.nil? || keyword.empty? # 空白やnilを配列から除外
      @topics = @topics.where(
        "content LIKE? AND user_id = ?",
        "%#{keyword}%", 1
      )
    end
  end

  def user_search
    # 空白で区切りand検索できるようにする
    keywords = params[:keyword].split(/[[:blank:]]+/)
    @topics = Topic.all
    keywords.each do |keyword|
      next if keyword.nil? || keyword.empty? # 空白やnilを配列から除外
      @topics = @topics.where(
        "content LIKE? AND user_id = ?",
        "%#{keyword}%", @current_user.id
      )
    end
    if @topics.nil?
      @error_message = "トピックが見つかりませんでした" 
    else
      @topics.count == 0
      @error_message = "トピックが見つかりませんでした"
    end
  end

end
