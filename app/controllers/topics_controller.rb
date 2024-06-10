class TopicsController < ApplicationController
  before_action :ensure_correct_user_by_user_id, {only: [:stock]}
  before_action :ensure_correct_user_by_topic_id, {
    only: [:edit, :update, :s_update, :s_create, :delete, :destroy, :s_destroy]
  }
  before_action :get_connections_from_topics, {
    only: [:edit, :update, :s_update, :s_create, :delete, :s_destroy]
  }

  # 非ログインユーザー用のストックページ
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

  # ストックの編集ページ
  def edit
  end

  # 話題の編集
  def update
    if Topic.exists?(content: params[:content], user_id: @current_user.id)
      # topicの保存に失敗した場合の処理
      @existing_error_message = "そのトピックは既にストックしています"
      render("users/edit", status: :unprocessable_entity)
    else
      @topic.update(content: params[:content])
      render("users/stock", status: :unprocessable_entity)
    end
  end

  # 類題の編集
  def s_update
    # テキストエリアを全く変えずに編集ボタンを押す、
    # 登録済の類題を編集によって紐づけようとする、などはエラーとする
    if Topic.exists?(content: params[:content], user_id: @current_user.id)
      @existing_error_message = "登録済のトピックを紐づけるにはストックしてください"
      render("users/edit", status: :unprocessable_entity)
    else # 編集後の内容が未登録なら編集を完了させる
      topic = Topic.find_by(id: params[:similar_topic_id])
      topic.update(content: params[:content])
      render("users/stock", status: :unprocessable_entity)
    end
  end

  # 類題の新規ストック
  def s_create
    # 新規登録した類題が既にDBに存在し、
    if existing_similar_topic = Topic.find_by(
        content: params[:content],
        user_id: @current_user.id
      )
      # 既に紐づいているならエラー
      if Connection.exists?(topic_id: params[:id], similar_topic_id: existing_similar_topic.id)
        @existing_error_message = "既に紐づいたトピックです"
        render("users/edit", status: :unprocessable_entity)
        # 紐づきが既に6つ以上あるならエラー
      elsif Connection.where(topic_id: existing_similar_topic.id).size > 5
        @existing_error_message = "1つのトピックに紐づけられるトピックは6つまでです"
        render("users/edit", status: :unprocessable_entity)
        # 同じ話題同士を紐づけようとしたらエラー
      elsif @topic.id == existing_similar_topic.id
        @existing_error_message = "同じ話題同士は紐づけられません"
        render("users/edit", status: :unprocessable_entity)
      else # 紐づいていなくてかつ紐づきが5つ以下なら紐づけを行う
        connect_existing_topic1 = Connection.create(
          topic_id:         params[:id],
          similar_topic_id: existing_similar_topic.id
        )
        connect_existing_topic2 = Connection.create(
          topic_id:         existing_similar_topic.id,
          similar_topic_id: params[:id]
        )
        render("users/stock", status: :unprocessable_entity)
      end
    else # 新規登録した類題がまだDBに存在しないならDBへの追加も行う
      topic = Topic.create(content: params[:content], user_id: @current_user.id)
      connection1 = Connection.create(topic_id: params[:id], similar_topic_id: topic.id)
      connection2 = Connection.create(topic_id: topic.id, similar_topic_id: params[:id])
      render("users/stock", status: :unprocessable_entity)
    end
  end

  # ストックの削除ページ
  def delete
  end
  
  # 話題の削除
  def destroy
    topic = Topic.find_by(id: params[:id]).destroy
    connection = Connection.where(similar_topic_id: params[:id]).destroy_all
    redirect_to("/users/#{@current_user.id}/stock")
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
    render("users/stock", status: :unprocessable_entity)
  end


  # アクセス制限
  def ensure_correct_user_by_user_id
    if @current_user
      session[:user_id] = nil
      redirect_to("/")
    end
  end
  # アクセス制限
  def ensure_correct_user_by_topic_id
    @topic = Topic.find_by(id: params[:id])
    if @current_user == nil
      redirect_to("/")
    elsif @topic == nil || @topic.user_id != @current_user.id
      redirect_to("/users/#{@current_user.id}")
    end
  end

  # ストックページ表示のためのメソッド
  def get_connections_from_topics
    @connections = Connection.where(topic_id: @topic.id)
  end

end
