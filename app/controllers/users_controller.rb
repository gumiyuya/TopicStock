class UsersController < ApplicationController
  before_action :ensure_correct_user_by_user_id, {
    only: [:home, :index, :stock, :new, :create, :bulk_create_form, :bulk_create]
  }

  # ログインページ
  def login_form
  end

  # ログイン成功時のみユーザーページへ
  def login
    @user = User.find_by(name: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to("/users/#{@user.id}")
    else
      @login_error_message = "ユーザー名またはパスワードが間違っています"
      @login_username = params[:username]
      render("users/login_form", status: :unprocessable_entity)
    end
  end

  # 新規登録成功時のみユーザーページへ
  def signup
    @user = User.new(name: params[:newname], password: params[:newpass])
    if @user.save
      session[:user_id] = @user.id
      redirect_to("/users/#{@user.id}")
    else
      @signup_error_message = "ユーザー名が既に存在します"
      @signup_username = params[:newname]
      render("users/login_form", status: :unprocessable_entity)
    end
  end

  # ログアウト
  def logout
    session[:user_id] = nil
    redirect_to("/")
  end

  # ユーザーのホームページ
  def home
    @topic_count = Topic.where(user_id: @current_user.id).count || 0
  end

  # ユーザーのストックページ
  def stock
    topics = Topic.where(user_id: @user.id)
    @topic = topics.find_by(id: params[:topic_id])
    if @topic
      @connections = Connection.where(topic_id: @topic.id)
    else
      @topic = topics[rand(topics.size)]
      if !@topic
        @not_yet_error_message = "まだトピックをストックしていません"
      else
        @connections = Connection.where(topic_id: @topic.id)
      end
    end
  end

  # ユーザーの新規ストックページ
  def new
  end

  # 話題の新規ストック
  def create
    @topic = Topic.new(content: params[:content], user_id: @current_user.id)
    if @topic.save
      redirect_to("/users/#{@topic.id}/edit")
    else
      @existing_error_message = "そのトピックは既にストックしています"
      render("users/new", status: :unprocessable_entity)
    end
  end

  # ユーザーのストック一覧ページ
  def index
    @topics = Topic.where(user_id: @current_user.id)
    if @topics.nil?
      @error_message = "トピックが見つかりませんでした" 
    else
      @topics.count == 0
      @error_message = "トピックが見つかりませんでした"
    end
  end

  # 話題一括生成ページ
  def bulk_create_form
    @topics = Topic.where(user_id: 1)
  end

  # 話題一括生成
  def bulk_create
    if @existing_topic
      redirect_to("/users/#{@current_user.id}/bulk_create_form")
    else
      topic_contents = [
        "天気の話", "季節の話", "雨", "アウトドアの話", "春", "夏", "秋", "冬", "ファッションの話", 
        "スポーツの話", "自宅での過ごし方", "湿気", "子どもの頃てるてる坊主作った？", 
        "好きな映画・最近見た映画", "住んでる場所", "自炊する？", "一人暮らし", "実家暮らし", 
        "今見てるドラマ・アニメ", "よく行くお気に入りの場所", "出身地", "料理の話", 
        "最寄り駅", "通勤・通学方法", "よく出かける場所", "車・バイクの話", "好きな漫画", 
        "趣味の話", "学生時代の部活", "部活内恋愛について", "放課後の思い出", "学生時代の思い出", 
        "文化祭の思い出", "修学旅行どこ行った？", "学生時代付き合ってた・好きだった人の話", 
        "子どもの頃の思い出", "何のバイトしてた？", "旅行の話", "朝のルーティン", "仕事の話", 
        "ヘアケアについて", "美容の話", "通ってるクリニック・ジム・美容院", "台風の思い出", 
        "ダイエットの話", "最近行った楽しかった場所", "デートスポット", "好きな芸能人", 
        "お気に入りのカフェや食べ物", "恋愛の話", "節約術", "家族の話"
      ]
      topic_contents.each do |topicContent|
        Topic.create!(
          user_id: @current_user.id,
          content: topicContent
        )
      end
      # 一括作成したトピックの内、最初のトピックのidを取得
      topic = Topic.find_by(user_id: @current_user.id, content: "天気の話")
      # 初期コネクション
      topic_ids         = [ 1, 2, 1, 3, 1, 4, 2, 5, 2, 6, 2, 7, 2, 8, 2, 9, 4, 10, 3, 11, 3, 12, 3, 13, 11, 14, 11, 15, 11, 16, 11, 17, 11, 18, 14, 19, 14, 20, 17, 16, 17, 21, 16, 22, 15, 23, 1, 24, 24, 23, 24, 25, 24, 26, 23, 25, 14, 27, 20, 25, 17, 28, 14, 28, 28, 26, 10, 29, 29, 30, 29, 31, 29, 32, 32, 33, 32, 34, 32, 35, 32, 36, 32, 37, 34, 38, 34, 21, 24, 39, 31, 24, 31, 25, 36, 13, 37, 40, 37, 31, 12, 41, 41, 42, 42, 43, 43, 25, 3, 44, 42, 39, 42, 45, 25, 46, 46, 47, 27, 19, 19, 48, 14, 48, 22, 45, 22, 49, 20, 49, 30, 50, 35, 50, 50, 47, 38, 21, 16, 51, 51, 38, 18, 52, 45, 10, 46, 4 ]
      similar_topic_ids = [ 2, 1, 3, 1, 4, 1, 5, 2, 6, 2, 7, 2, 8, 2, 9, 2, 10, 4, 11, 3, 12, 3, 13, 3, 14, 11, 15, 11, 16, 11, 17, 11, 18, 11, 19, 14, 20, 14, 16, 17, 21, 17, 22, 16, 23, 15, 24, 1, 23, 24, 25, 24, 26, 24, 25, 23, 27, 14, 25, 20, 28, 17, 28, 14, 26, 28, 29, 10, 30, 29, 31, 29, 32, 29, 33, 32, 34, 32, 35, 32, 36, 32, 37, 32, 38, 34, 21, 34, 39, 24, 24, 31, 25, 31, 13, 36, 40, 37, 31, 37, 41, 12, 42, 41, 43, 42, 25, 43, 44, 3, 39, 42, 45, 42, 46, 25, 47, 46, 19, 27, 48, 19, 48, 14, 45, 22, 49, 22, 49, 20, 50, 30, 50, 35, 47, 50, 21, 38, 51, 16, 38, 51, 52, 18, 10, 45, 4, 46 ]
      # 取得したトピックのidと初期コネクションのトピックidを足して新たに配列を生成
      first_topic_ids_for_user = topic_ids.map {
        |topicId| topic.id + topicId - 1
      }
      first_similar_topic_ids_for_user = similar_topic_ids.map {
        |similarTopicId| topic.id + similarTopicId - 1
      }
      # 生成された配列が@current_userにとっての初期コネクションとなり、
      # 話題との紐づけも一括生成される
      first_topic_ids_for_user.zip(first_similar_topic_ids_for_user) do
        |first_topic_id_for_user, first_similar_topic_id_for_user|
        Connection.create!(
          topic_id: first_topic_id_for_user,
          similar_topic_id: first_similar_topic_id_for_user
        )
      end
      redirect_to("/users/#{@current_user.id}")
    end
  end

  # アクセス制限
  def ensure_correct_user_by_user_id
    @user = User.find_by(id: params[:id])
    if @user == nil || !@current_user
      redirect_to("/")
    elsif @user.id != @current_user.id
      session[:user_id] = nil
      redirect_to("/")
    end
  end

end
