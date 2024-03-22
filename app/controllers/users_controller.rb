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
  end

  # ユーザーのストックページ
  def stock
    user = User.find_by(id: params[:id])
    topics = Topic.where(user_id: user.id)
    @random_topic = topics[rand(topics.size)]
    @connections = Connection.where(topic_id: @random_topic.id)
  end

  def new
  end

  def create
    @topic = Topic.new(content: params[:content], user_id: @current_user.id)
    @similar_topic = SimilarTopic.new(content: params[:content], user_id: @current_user.id)
    if @topic.save && @similar_topic.save
      redirect_to("/users/#{@topic.id}/edit")
    else
      @existing_error_message = "そのトピックは既にストックしています"
      render("users/new")
    end
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
    topic.content = params[:content]
    similar_topic = SimilarTopic.find_by(id: params[:id])
    similar_topic.content = params[:content]
    if topic.save && similar_topic.save
      redirect_to("/users/#{@current_user.id}/stock")
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
    
    # テキストエリアを全く変えずに編集ボタンを押す、
    # 既にある類題を登録しようとする、などはエラーとする
    if SimilarTopic.exists?(content: params[:content], user_id: @current_user.id)
      @existing_error_message = "そのトピックは既にストックしています"
      render("users/edit")
    else
      topic = Topic.find_by(id: params[:similar_topic_id])
      topic.content = params[:content]
      similar_topic = SimilarTopic.find_by(id: params[:similar_topic_id])
      similar_topic.content = params[:content]
      if topic.save && similar_topic.save
        redirect_to("/users/#{@current_user.id}/stock")
      else
        # topic,similar_topicの保存に失敗した場合の処理
        @existing_error_message = "1つのトピックに紐づけられるトピックは6つまでです"
        render("users/edit")
      end
    end
  end

  # 新規類題登録
  def s_create
    # renderのための変数
    @topic = Topic.find_by(id: params[:id])
    @connections = Connection.where(topic_id: @topic.id)
    
    # 新規登録した類題が既にDBに存在し、
    if existing_similar_topic = SimilarTopic.find_by(
        content: params[:content],
        user_id: @current_user.id
      )
      # かつ既に紐づいているならエラー
      if Connection.exists?(topic_id: params[:id], similar_topic_id: existing_similar_topic.id)
        @existing_error_message = "そのトピックは既にストックしています"
        render("users/edit")
      else # 紐づいていなければ紐づけを行う
        connect_existing_topic1 = Connection.new(
          topic_id:         params[:id],
          similar_topic_id: existing_similar_topic.id
        )
        connect_existing_topic2 = Connection.new(
          topic_id:         existing_similar_topic.id,
          similar_topic_id: params[:id]
        )
        if connect_existing_topic1.save && connect_existing_topic2.save
          redirect_to("/users/#{@current_user.id}/stock")
        else
          # 紐づけに失敗した場合の処理
          @existing_error_message = "1つのトピックに紐づけられるトピックは6つまでです"
          render("users/edit")
        end
      end
    else # 新規登録した類題がまだDBに存在しないならDBへの追加も行う
      topic = Topic.create(content: params[:content], user_id: @current_user.id)
      similar_topic = SimilarTopic.create(content: params[:content], user_id: @current_user.id)
      connection1 = Connection.create(topic_id: params[:id], similar_topic_id: similar_topic.id)
      connection2 = Connection.create(topic_id: similar_topic.id, similar_topic_id: params[:id])
      redirect_to("/users/#{@current_user.id}/stock")
    end
  end

  # ストックの削除ページ
  def delete
    @topic = Topic.find_by(id: params[:id])
    @connections = Connection.where(topic_id: @topic.id)
  end
  
  # 話題の削除
  def destroy
    topic = Topic.find_by(id: params[:id]).destroy
    similar_topic = SimilarTopic.find_by(id: params[:id]).destroy
    # 紐づきがあれば全ての紐づきを削除
    if connection1 = Connection.where(topic_id: params[:id])
      connection1.destroy_all
      connection2 = Connection.where(similar_topic_id: params[:id]).destroy_all
      redirect_to("/users/#{@current_user.id}/stock")
    else # なければそのままページ遷移
      redirect_to("/users/#{@current_user.id}/stock")
    end
  end

  # 類題との紐づきの削除
  def s_destroy
    connection1 = Connection.find_by(
      topic_id:         params[:id],
      similar_topic_id: params[:similar_topic_id]
      ).destroy
    connection2 = Connection.find_by(
      topic_id:         params[:similar_topic_id],
      similar_topic_id: params[:id]
      ).destroy
    redirect_to("/users/#{@current_user.id}/stock")
  end

end
