module SessionsHelper
  def log_in (user)
    session[:user_id] = user.id;
  end
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id]);
    elsif
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(cookies[:remember_token]);
        log_in user
        @current_user = user
      end
    end
  end
  def logged_in?
    return !current_user.nil?
  end
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies[:user_id] = { value:   user.id,
                          expires: 20.years.from_now.utc }
    cookies[:remember_token] = { value:   user.remember_token,
                                 expires: 20.years.from_now.utc }
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
end
