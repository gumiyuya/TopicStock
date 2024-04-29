class HomeController < ApplicationController
  before_action :ensure_correct_user_by_user_id

  def top
  end

  # アクセス制限
  def ensure_correct_user_by_user_id
    if @current_user
      session[:user_id] = nil
    end
  end
end
