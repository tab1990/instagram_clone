class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy,:post_file]
  before_action :authority_check, only: [:edit, :update, :destroy,:post_file]

  def index
    if params[:user_id].present?
      @posts = Post.where(user_id: params[:user_id]).order(updated_at: :desc)
    else
      @posts = Post.all.order(updated_at: :desc)
    end
  end

  def show
    @favorite = current_user.favorites.find_by(post_id: @post.id) if current_user.present?
  end

  def new
    if params[:back]
      @post = Post.new(post_params)
    else
      @post = Post.new
    end
  end

  def edit
  end

  def confirm
    @post=current_user.posts.build(post_params)
    render 'new' if @post.invalid?
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      PostMailer.post_mail(@post).deliver
      redirect_to posts_path, notice: '投稿しました'
    else
      render 'new'
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: '削除しました'
  end

  def post_file
    if @post.image.url
      @post.remove_image!
      @post.save
      flash[:notice]='画像を削除しました'
      redirect_to post_path(@post.id)
    else
      flash.now[:notice]="画像はありません"
      render 'edit'
    end
  end

  def favorite
    @posts = current_user.favorite_posts
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.fetch(:post, {}).permit(:content,:image,:image_cache)
  end

  def authority_check
    unless current_user.present? && current_user.id == @post.user.id
      redirect_to posts_path
      flash[:notice] = 'アクセス権がありません'
    end
  end
end
