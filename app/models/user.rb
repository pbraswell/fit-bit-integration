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
  has_many :authorizations

  def self.from_omniauth(auth)
    # [todo] - Need to catch when a user has already authorized for a given provider
    # [todo] - Make sure that reauthorizing with a provide updates credentials.  Issue with FitBit
    where(:username => 'peter.braswell').first_or_create do |user|
      user.authorizations << Authorization.create(:provider => auth.provider,
                                                  :user_id => auth.uid,
                                                  :oauth_token => auth['credentials']['token'],
                                                  :oauth_secret => auth['credentials']['secret'])
      user.save
      user
    end
  end

  def test
    consumer_key = ENV['FIT_BIT_CONSUMER_KEY']
    consumer_secret = ENV['FIT_BIT_CONSUMER_SECRET']
    puts "using #{consumer_key} and #{consumer_secret}"
    @consumer = OAuth::Consumer.new(consumer_key, consumer_secret,{
                               :site => "http://api.fitbit.com"})

    # # make the access token from your consumer
    # access_token = OAuth::AccessToken.new (self.authorizations.first.oauth_token, self.authorizations.first.oauth_secret)
    puts "using #{self.authorizations.first.oauth_token} and #{self.authorizations.first.oauth_secret}"
    @access_token = OAuth::AccessToken.new(@consumer, self.authorizations.first.oauth_token, self.authorizations.first.oauth_secret) 
    # # make a signed request!  
    json = @access_token.get("/1/user/2GF3NR/sleep/date/2014-05-01.json").body
    sleep_record = JSON.parse(json)
    puts "time to bed : #{sleep_record["sleep"][0]["startTime"]}"
    puts "time to fall asleep: #{sleep_record["sleep"][0]["minutesToFallAsleep"]}"
    puts "awakenings count: #{sleep_record["sleep"][0]["awakeningCount"]}"
    puts "awake duration: #{sleep_record["sleep"][0]["awakeDuration"]}"
    puts "minutes asleep: #{sleep_record["sleep"][0]["minutesAsleep"]}"
    puts "time in bed: #{sleep_record["sleep"][0]["minutesAsleep"]}"
  end

end
