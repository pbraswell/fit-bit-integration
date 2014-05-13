class SleepLogsController < ApplicationController
  def index
  end

  def show
    logger.info "fetch sleep record for: #{params[:username]}"
    @user = User.find_by_username params[:username]
    @sleep_log = @user.get_todays_sleep_log unless @user.nil?
  end
end
