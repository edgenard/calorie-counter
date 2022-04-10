class ApplicationController < ActionController::Base
 include ApplicationHelper


 private

 def login(params)
    result = AuthenticateUser.call(params)
    if result.success?
      session[:token] = result.success[:token]
      redirect_to user_path(result.success[:user])
    else
      flash.now[:error] = "Invalid Credentials"
      render :new, status: :unprocessable_entity
    end
 end
end
