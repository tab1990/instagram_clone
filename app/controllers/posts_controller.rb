class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy,:post_file]
  before_action :authority_check, only: [:edit, :update, :destroy,:post_file]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
    if params[:back]
      @post = Post.new(post_params)
    else
      @post = Post.new
    end
  end

  def edit
    unless current_user.id == @post.user.id
      redirect_to posts_path
      flash[:notice] = 'アクセス権がありません'
    end
  end

  def confirm
    @post=current_user.posts.build(post_params)
    render 'new' if @post.invalid?
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      PostMailer.post_mail(@post).deliver
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render 'new'
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully destroyed.'
  end

  def post_file
    @post.remove_image!
    @post.save
    flash[:notice]='画像を削除しました'
    redirect_to post_path(@post.id)
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.fetch(:post, {}).permit(:content,:image,:image_cache)
    end

    def authority_check
      unless current_user.id == @post.user.id
        redirect_to posts_path
        flash[:notice] = 'アクセス権がありません'
      end
    end
end
