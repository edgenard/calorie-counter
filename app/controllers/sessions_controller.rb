class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def create
    result = AuthenticateUser.call(session_params)
    if result.success?
      session[:token] = result.success[:token]
      redirect_to user_path(result.success[:user])
    else
      flash.now[:error] = "Invalid Credentials"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def current_user
    @current_user ||= if session[:token]
      result = AuthenticateRequest.call(session[:token])
      return result.success if result.success?
    end
    false
  end
end
