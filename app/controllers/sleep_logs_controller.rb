class SleepLogsController < ApplicationController
  respond_to :html, :xml, :json

  def index
  end

  def show
    logger.info "fetch sleep log for: #{params[:username]}"
    @user = User.find_by_username params[:username]
    @sleep_log = @user.get_todays_sleep_log unless @user.nil?
    respond_with(@sleep_log)
  end

  def get_by_date
    logger.info "fetch sleep log by user name date"
    @user = User.find_by_username params[:username]
    @sleep_log = @user.get_todays_sleep_log unless @user.nil?
    respond_with(@sleep_log)
  end

end
