class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @posts = @user.posts
    else
      @posts = Post.all
    end
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to user_path(current_user.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  private
  def post_params
    params.require(:post).permit(:title, :body)
  end
end
