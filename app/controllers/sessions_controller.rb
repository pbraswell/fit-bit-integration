class SessionsController < ApplicationController

  def create
   
    auth_hash = request.env["omniauth.auth"]

    user = User.from_omniauth auth_hash, session[:external_user]
    logger.info "user in session is #{session[:external_user]}"
    if user.persisted?
      flash.notice = "Signed in!"
      redirect_to session[:return_to] ||= request.referer, :notice => "FitBit linked!"
    else
      flash.notice = "Not signed in, need to redirect!"
      redirect_to '/sleep_logs/index'
    end
  end

end
