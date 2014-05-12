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

require 'spec_helper'

describe User do
  
  context 'creating new authorizations' do
  
    it 'should not create a new authorization if one already exists' do
      auth_hash = OmniAuth.config.mock_auth[:fitbit] = OmniAuth::AuthHash.new({
          :provider => 'fitbit',
          :uid => '123545',
          :credentials => {:token => '1234', :secret => '56789'}
      })

      2.times do
        @user = User.from_omniauth(auth_hash)
      end
      expect(@user.authorizations.length).to eq(1)
      expect(User.count).to eq(1)
    end
 
    it 'should replace oauth credentials if reauthorizing the app' do
      auth_hash_one = OmniAuth.config.mock_auth[:fitbit] = OmniAuth::AuthHash.new({
          :provider => 'fitbit',
          :uid => '123545',
          :credentials => {:token => '1234', :secret => '56789'}
      })

      auth_hash_two = OmniAuth.config.mock_auth[:fitbit] = OmniAuth::AuthHash.new({
          :provider => 'fitbit',
          :uid => '123545',
          :credentials => {:token => '0000', :secret => '9999'}
      })

      @user = User.from_omniauth auth_hash_one
      expect(@user.authorizations.first.oauth_token).to eq (auth_hash_one['credentials']['token'])
      expect(@user.authorizations.first.oauth_secret).to eq (auth_hash_one['credentials']['secret'])
      @user = User.from_omniauth auth_hash_two
      expect(@user.authorizations.first.oauth_token).to eq (auth_hash_two['credentials']['token'])
      expect(@user.authorizations.first.oauth_secret).to eq (auth_hash_two['credentials']['secret'])
    end 
   
  end

end
