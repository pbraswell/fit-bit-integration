class AuthorizationController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :auth_fitbit
  respond_to :html, :xml, :json

  def auth_fitbit
    session[:external_user] = params[:external_user]
    session[:return_to] ||= request.referer
    redirect_to '/auth/fitbit/'
  end

  def is_linked
    response = {:exists => User.exists?(params[:id])} 
    respond_with(response)
  end

end
