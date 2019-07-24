class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy edit_password edit_pass profile_file]
  before_action :authority_check, only: %i[edit update destroy edit_password edit_pass profile_file]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @posts = @user.posts
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'ユーザ登録が完了しました！'
      redirect_to posts_path
    else
      flash.now[:danger] = 'ユーザ登録できませんでした'
      render 'new'
    end
  end

  def update
    if @user.email != 'test@tbc.com' && @user.update(user_params)
      flash[:success] = 'ユーザ情報を更新しました'
      redirect_to user_path
    else
      flash.now[:notice] = '更新に失敗しました(＃テストユーザでログインしている場合は編集できません。機能表示のために、あえてボタンは表示させてます。)'
      render 'edit'
    end
  end

  def destroy
    if @user.email != 'test@tbc.com' && @user.destroy
      session.delete(:user_id)
      flash[:notice] = 'ユーザ登録を削除しました'
      redirect_to new_user_path
    else
      flash[:notice] = 'ユーザ登録を削除できませんでした(＃テストユーザでログインしている場合は削除できません。機能表示のために、あえてボタンは表示させてます。)'
      redirect_to user_path(@user.id)
    end
  end

  def edit_password; end

  def edit_pass
    if @user.email != 'test@tbc.com' && @user.authenticate(params[:user][:old_password]) && @user.update(user_params)
      flash[:notice] = 'パスワードを更新しました'
      redirect_to user_path
    else
      flash.now[:notice] = 'パスワードを更新できませんでした(＃テストユーザでログインしている場合は更新できません。)'
      render 'edit_password'
    end
  end

  def profile_file
    if @user.image.url
      @user.remove_image!
      @user.save
      flash[:notice] = '画像を削除しました'
      redirect_to user_path(@user.id)
    else
      flash.now[:notice] = '画像はありません'
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image, :remove_image)
  end

  def authority_check
    return false if current_user == @user

    flash[:notice] = 'アクセス権限がありません'
    redirect_to posts_path
  end
end
