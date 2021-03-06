class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destory]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user , only: [:destory]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
    #返回所有用户
    # @users = User.paginate(page: params[:page])
    #只返回已经激活的用户
    @users = User.where(activated: true).paginate(page: params[:page])
    # @users = User.where(activated: FILL_IN).paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # log_in @user
      # flash[:success] = "Welcome to the Sample App"
      # redirect_to @user

      # UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:success] = "check your email to activate your accounto"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else 
      render 'edit'
    end
  end

   

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  private

  # def user_params
  #   params.require(:user).permit(:name, :email, :password, :password_confirmation)
  # end
    def user_params
          params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
