class UsersController < ApplicationController

  # ログインページ
  def login_form
    @user = User.new
  end

  # ログイン成功時のみユーザーページへ
  def login
    @user = User.find_by(
      name:     params[:username],
      password: params[:password]
    )
    if @user
      session[:user_id] = @user.id
      redirect_to("/users/#{@user.id}")
    else
      @login_error_message = "ユーザー名またはパスワードが間違っています"
      @login_username = params[:username]
      render("users/login_form")
    end
  end

  # 新規登録成功時のみユーザーページへ
  def signup
    @user = User.new(
    name:     params[:newname],
    password: params[:newpass]
    )
    if @user.save
      redirect_to("/users/#{@user.id}")
    else
      @signup_error_message = "ユーザー名が既に存在します"
      @signup_username = params[:newname]
      render("users/login_form")
    end
  end

  # ログアウト
  def logout
    session[:user_id] = nil
    redirect_to("/TopicStock")
  end

  # ユーザーのホームページ
  def home
    @user = User.find_by(id: params[:id])
  end

  # ユーザーのストックページ
  def stock
    user = User.find_by(id: params[:id])
    topics = Topic.where(user_id: user.id)
    @random_topic = topics[rand(topics.size)]
    @connections = Connection.where(topic_id: @random_topic.id)
  end

  # ストックの編集ページ
  def edit
    @topic = Topic.find_by(id: params[:id])
    @connections = Connection.where(topic_id: @topic.id)
  end

  # 話題の編集
  def update
    # renderのための変数
    @topic = Topic.find_by(id: params[:id])
    @connections = Connection.where(topic_id: @topic.id)

    topic = Topic.find_by(id: params[:id])
    topic.content = params[:topic]
    similar_topic = SimilarTopic.find_by(id: params[:id])
    similar_topic.content = params[:topic]
    if topic.save && similar_topic.save
      redirect_to("/users/#{topic.user_id}/stock")
    else
      # topic,similar_topicの保存に失敗した場合の処理
      @existing_error_message = "そのトピックは既にストックしています"
      render("users/edit")
    end
  end

  # 類題の編集
  def s_update
    # renderのための変数
    @topic = Topic.find_by(id: params[:id])
    @connections = Connection.where(topic_id: @topic.id)

    topic = Topic.find_by(id: params[:id])
    topic.content = params[:update_similar_topic]
    similar_topic = SimilarTopic.find_by(id: params[:id])
    similar_topic.content = params[:update_similar_topic]
    if topic.save && similar_topic.save
      redirect_to("/users/#{topic.user_id}/stock")
    else
      # topic,similar_topicの保存に失敗した場合の処理
      @existing_error_message = "そのトピックは既にストックしています"
      render("users/edit")
    end
  end

  # 類題の削除
  def s_destroy
    topic = Topic.find_by(id: params[:id]).destroy
    similar_topic = SimilarTopic.find_by(id: params[:id]).destroy
    connection1 = Connection.find_by(topic_id: params[:id]).destroy
    connection2 = Connection.find_by(similar_topic_id: params[:id]).destroy
    redirect_to("/users/#{@current_user.id}/stock")
  end

  # 新規類題登録
  def s_create
    # 新規登録した類題が既にDBに存在するなら紐づけのみ行う
    if SimilarTopic.exists?(content: params[:create_similar_topic], user_id: @current_user.id)
      existing_similar_topic = SimilarTopic.find_by(
        content: params[:create_similar_topic],
        user_id: @current_user.id
      )
      connect_existing_topic1 = Connection.create(
        topic_id:         params[:id],
        similar_topic_id: existing_similar_topic.id
      )
      connect_existing_topic2 = Connection.create(
        topic_id:         existing_similar_topic.id,
        similar_topic_id: params[:id]
      )
      redirect_to("/users/#{@current_user.id}/stock")
    else # 新規登録した類題がまだDBに存在しないならDBへの追加も行う
      topic = Topic.create(content: params[:create_similar_topic], user_id: @current_user.id)
      similar_topic = SimilarTopic.create(content: params[:create_similar_topic], user_id: @current_user.id)
      connection1 = Connection.create(topic_id: params[:id], similar_topic_id: similar_topic.id)
      connection2 = Connection.create(topic_id: similar_topic.id, similar_topic_id: params[:id])
      redirect_to("/users/#{@current_user.id}/stock")
    end
  end

end
