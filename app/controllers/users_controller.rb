class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    result = CreateUser.call(user_params)
    if result.success?
      user = result.success
      login({email: user.email, password: user.password})
    else
      @user = result.failure[:user]
      flash.now[:error] = result.failure[:message]
      render action: "new", status: :unprocessable_entity
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
