class ApplicationController < ActionController::Base
  # ログインしていないユーザーをログイン画面に転送する
  before_action :authenticate_user!
end