class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def create
    login(session_params)
  end

  def destroy
    session.delete(:token)
    flash[:notice] = "Logged Out"
    redirect_to root_path, status: :see_other
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
