class AuthorizationController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :auth_fitbit
  def auth_fitbit
    session[:external_user] = params[:external_user]
    redirect_to '/auth/fitbit/'
  end
end
