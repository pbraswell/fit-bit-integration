class AuthorizationController < ApplicationController
  def auth_fitbit
    session[:external_user] = params[:external_user]
    redirect_to '/auth/fitbit/'
  end
end
