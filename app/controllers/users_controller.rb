class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.persisted?
      redirect_to user_path(@user)
    else
      flash.now[:error] = @user.errors.full_messages.join(", ")
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
