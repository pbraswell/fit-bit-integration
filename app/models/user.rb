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

  def test
    consumer_key = ENV['FIT_BIT_CONSUMER_KEY']
    consumer_secret = ENV['FIT_BIT_CONSUMER_SECRET']
    puts "using #{consumer_key} and #{consumer_secret}"
    @consumer = OAuth::Consumer.new(consumer_key, consumer_secret,{
                               :site => "http://api.fitbit.com"})
    date = DateTime.now

    # # make the access token from your consumer
    # access_token = OAuth::AccessToken.new (self.authorizations.first.oauth_token, self.authorizations.first.oauth_secret)
    puts "using #{self.authorizations.first.oauth_token} and #{self.authorizations.first.oauth_secret}"
    @access_token = OAuth::AccessToken.new(@consumer, self.authorizations.first.oauth_token, self.authorizations.first.oauth_secret) 
    # # make a signed request!  
    json = @access_token.get("/1/user/#{self.username}/sleep/date/#{date.strftime("%Y-%m-%d")}.json").body
    puts json
    # sleep_record = JSON.parse(json)
    # puts "time to bed : #{sleep_record["sleep"][0]["startTime"]}"
    # puts "time to fall asleep: #{sleep_record["sleep"][0]["minutesToFallAsleep"]}"
    # puts "awakenings count: #{sleep_record["sleep"][0]["awakeningCount"]}"
    # puts "awake duration: #{sleep_record["sleep"][0]["awakeDuration"]}"
    # puts "minutes asleep: #{sleep_record["sleep"][0]["minutesAsleep"]}"
    # puts "time in bed: #{sleep_record["sleep"][0]["minutesAsleep"]}"
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

end
