class SessionsController < ApplicationController

  def create
   
    auth_hash = request.env["omniauth.auth"]

    user = User.from_omniauth auth_hash
    if user.persisted?
      flash.notice = "Signed in!"
      redirect_to '/sleep_logs/index'
    else
      flash.notice = "Not signed in, need to redirect!"
      redirect_to '/sleep_logs/index'
    end
  end

end
