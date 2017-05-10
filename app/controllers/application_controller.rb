class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  def logged_in_user
      unless logged_in?
        # byebug
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      else
        # byebug
      end
    end
end
