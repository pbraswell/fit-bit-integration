class SessionsController < ApplicationController

  def create
   
    auth_hash = request.env["omniauth.auth"]

    user = User.from_omniauth(auth_hash)
    if user.persisted?
      flash.notice = "Signed in!"
      redirect_to '/'
    else
      flash.notice = "Not signed in, need to redirect!"
      redirect_to '/'
    end
  end

end
