class SearchesController < ApplicationController
  before_action :ensure_correct_user1, {
    only: [:search]
  }
  before_action :ensure_correct_user2, {
    only: [:user_search]
  }

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

  # アクセス制限
  def ensure_correct_user1
    if @current_user
      redirect_to("/users/#{@current_user.id}")
    end
  end
  def ensure_correct_user2
    if !@current_user
      redirect_to("/")
    end
  end

end
