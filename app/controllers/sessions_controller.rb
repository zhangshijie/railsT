class SessionsController < ApplicationController
  def new
  end


# 参数 包含 email password 的session 集合
# 通过email password 查找 user
# 通过sessions_helper里定义的log_in 方法，往session里塞user.id
# 判断 是否记住，
#  是： 则 1.0调用sessions_helper里的 remember方法 
            #  1.1继而调用user.rb的remember方法  生成记忆令牌 remember_token
            #  1.2将其摘要保存到数据库users表的remember_digest字段
        # 2.0 将用户id 签名并加密 和 记忆令牌remember_token 一起 保存到cookies

# 否：  则 1.0 调用sessions_helper里的 forget 方法
            #  1.1继而调用user.rb的forget方法  删除Users表里记录 对应的 users表的remember_digest字段
        # 2.0 删除cookies里的user_id和 remember_token 
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user

    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end

  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
