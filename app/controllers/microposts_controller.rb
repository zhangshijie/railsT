class MicropostsController < ApplicationController
  before_action :logged_in_user , only: [:create, :destroy]

  def create
    micropost = current_user.microposts.build(micropost_params)
    if micropost.save
      flash[:success] = "Post success"
      redirect_to root_url
    else
      redirect_to "static_pages/home"
    end
  end

  def destory
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
