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
  delegate :provider, :oauth_token, :oauth_secret, to: :authorization

  def self.from_omniauth(auth)
    where(:username => 'peter.braswell').first_or_create do |user|
      user.authorizations << Authorization.create(:provider => auth.provider,
                                                  :user_id => auth.uid,
                                                  :oauth_token => auth['credentials']['token'],
                                                  :oauth_secret => auth['credentials']['secret'])
      user.save
      user
    end
  end
end
