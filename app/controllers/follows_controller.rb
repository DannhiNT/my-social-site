class FollowsController < ApplicationController
  before_action :authenticate_user!
  def create
    @user = User.find(params[:followed_id])
    unless current_user.pending_followings.include?(@user) || current_user.followings.include?(@user)
      current_user.active_follows.create(followed_id: @user.id, status: "pending")
    end
    redirect_to posts_path, notice: "Follow request sent to #{@user.username}."
  end

  def approve
    @follow = current_user.pending_passive_follows.find(params[:id])
    @follow.update(status: "accepted")
    redirect_to pending_followers_user_path, notice: "You approved the follow request!"
  end

  def destroy
    @follow = Follow.find(params[:id])
    if @follow.follower == current_user || @follow.followed == current_user
      @follow.destroy
      redirect_to user_path(current_user.id), notice: "Follow removed!"
    else
      redirect_to user_path(current_user.id), alert: "Not authorized."
    end
  end
end
