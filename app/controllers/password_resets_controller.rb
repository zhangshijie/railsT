class PasswordResetsController < ApplicationController
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
end
