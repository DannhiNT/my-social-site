class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings
  end
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers
  end

  def pending_followers
    @user = User.find(params[:id])
    @pending_followers = @user.pending_followers
  end
end
