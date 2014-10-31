class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # authorize_resource
  respond_to :html

  def index
    @posts = Post.all
    respond_with(@posts)
  end

  def show
    authorize! :show, @post

    respond_with(@post)
  end

  def new
    @post = Post.new
    respond_with(@post)
  end

  def edit
    authorize! :edit, @post
  end

  def create
    @post = Post.new(post_params)
    @post = current_user.posts.build(post_params)
    @post.save
    respond_with(@post)
  end

  def update
    authorize! :update, @post
    @post.update(post_params)
    respond_with(@post)
  end

  def destroy
    authorize! :destroy, @post
    @post.destroy
    respond_with(@post)
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :context, :restricted)
    end
end
