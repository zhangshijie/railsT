module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    # @current_user ||= User.find_by(id: session[:user_id])
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      # raise #测 试仍能通过，所以没有覆盖这分支
      user = User.find(id: user_id)
      if user && user.authenticated?(:remember,cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end 
  end


  def logged_in?
    !current_user.nil?
  end

  #在持久会话中记住用户
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

# 重定向到存储的地址或默认地址
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  #存储后面需要使用的地址
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
