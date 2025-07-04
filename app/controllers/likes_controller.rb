class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.likes.create(post: @post)
    redirect_to params[:redirect_to] || posts_path
  end

  def destroy
    @post = Post.find(params[:id])
    like = current_user.likes.find_by(post: @post)
    like.destroy if like
    redirect_to params[:redirect_to] || posts_path
  end
end
