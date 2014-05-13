# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string(255)
#  auth_hash  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :username, uniqueness: true
  has_many :authorizations

  def self.from_omniauth auth
    user = where(:username => auth.uid).first_or_create do |user|
      logger.info "creating user on auth request"
      user.save
    end
    user.create_or_update_provider_credentials auth
    user
  end

  def get_todays_sleep_log 
    get_sleep_log_by_date (Date.today)
  end

  def get_sleep_log_by_date date
    logger.info "getting todays sleep log for #{self.username}"
    consumer_key = ENV['FIT_BIT_CONSUMER_KEY']
    consumer_secret = ENV['FIT_BIT_CONSUMER_SECRET']
    @consumer = OAuth::Consumer.new(consumer_key, consumer_secret,{
                               :site => "http://api.fitbit.com"})
    @access_token = OAuth::AccessToken.new(@consumer, 
                                           self.authorizations.first.oauth_token, 
                                           self.authorizations.first.oauth_secret)
    response = @access_token.get("/1/user/#{self.username}/sleep/date/#{date.strftime("%Y-%m-%d")}.json").body
    post_process_response (JSON.parse response)
  end

  def create_or_update_provider_credentials auth
    puts "authorizations: #{self.authorizations.length}"
    if self.authorizations.length > 0 
      puts "deleting authorization"
      self.authorizations.delete_all
    end
    self.authorizations << Authorization.create(:provider => auth.provider,
                                                :user_id => auth.uid,
                                                :oauth_token => auth['credentials']['token'],
                                                :oauth_secret => auth['credentials']['secret'])
  end

  protected

    def post_process_response response
      formated_response = {
        :minutes_to_fall_asleep => response["sleep"].first["minutesToFallAsleep"],
        :awakenings_count => response["sleep"].first["awakeningsCount"],
        :awake_duration => response["sleep"].first["awakeDuration"],
        :minutes_asleep => response["sleep"].first["minutesAsleep"],
        :time_in_bed => response["sleep"].first["timeInBed"]
      }
    end


end
