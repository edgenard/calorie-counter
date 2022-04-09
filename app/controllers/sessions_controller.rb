class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      redirect_to user_path(user)
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
    if session[:token]
      result = AuthenticateRequest.new(session[:token]).execute
      return result.value if result.success?
    end
    false
  end
end
