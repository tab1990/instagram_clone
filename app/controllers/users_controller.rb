class UsersController < ApplicationController
  before_action :set_user,only: [:show,:edit,:update,:destroy,:edit_password,:edit_pass,:profile_file]
  before_action :authority_check,only: [:show,:edit,:update,:destroy,:edit_password,:edit_pass,:profile_file]

  def new
    @user=User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id]= @user.id
      redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    session.delete(:user_id)
    flash[:notice]='ユーザ登録を削除しました'
    redirect_to new_user_path
  end

  def edit_password
  end

  def edit_pass
      if @user.authenticate(params[:user][:old_password]) && @user.update(user_params)
        flash[:notice] = "パスワードを更新しました"
        redirect_to user_path
      else
        flash.now[:notice] = "パスワードが更新できませんでした"
        render 'edit_password'
      end
  end

  def profile_file
    @user.remove_image!
    @user.save
    redirect_to user_path(@user.id)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation,:image,:remove_image)
  end

  def authority_check
    unless current_user.id == @user.id
      flash[:notice] = 'アクセス権限がありません'
      redirect_to user_path(current_user.id)
    end
  end
end
