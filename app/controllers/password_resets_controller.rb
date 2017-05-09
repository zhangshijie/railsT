class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      #创建重设密码摘要
      @user.create_reset_digest
      #发送邮件
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash[:danger] =  "Email address not found"
      render 'new'
    end
  end

  def index
  end

  def show
  end

  def update
    if params[:user][:password].empty?
      @user.error.add(:password, "can not be empty ")
      render 'new'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "password has been reset"
      redirect_to @user
    else
       render 'edit'
    end
  end

  private
     def user_params
       params.require(:user).permit(:password, :password_confirmation)
     end

     def get_user
       @user = User.find_by(params[:id])
     end

     def valid_user
       unless ( @user && @user.activated? && @user.authenticated?(:reset, params[:id])
     end

     def check_expiration
       if @user.password_reset_expired?
         flash[:danger] = "Password reset has expired."
         redirect_to new_password_reset_url
       end
     end
end
