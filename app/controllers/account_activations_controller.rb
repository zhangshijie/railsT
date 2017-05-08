class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if use && !user.activated && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated !"
    else 
      flash[:danger] = "Invalid activation link"
      redirected_to root_url
    end
  end
end
