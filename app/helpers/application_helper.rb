module ApplicationHelper
  def current_user
    @current_user ||= if session[:token]
      result = AuthenticateRequest.call(session[:token])
      return result.success if result.success?
    end
    false
  end

  def logged_in?
      !!current_user
  end
end
