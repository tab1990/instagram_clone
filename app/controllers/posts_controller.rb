class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy,:post_file]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    if params[:back]
      @post = Post.new(post_params)
    else
      @post = Post.new
    end
  end

  # GET /posts/1/edit
  def edit
  end

  def confirm
    @post=current_user.posts.build(post_params)
    render 'new' if @post.invalid?
  end

  def create

    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render 'new'
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
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
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.fetch(:post, {}).permit(:content,:image,:image_cache)
    end
end
