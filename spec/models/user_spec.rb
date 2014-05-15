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

    let!(:external_user) {"12345"}
    let!(:auth_hash) {
        OmniAuth.config.mock_auth[:fitbit] = OmniAuth::AuthHash.new({
          :provider => 'fitbit',
          :uid => '123545',
          :credentials => {:token => '1234', :secret => '56789'}
      })
    }
  
    it 'should not create a new authorization if one already exists' do

      2.times do
        @user = User.from_omniauth auth_hash, external_user
      end
      expect(@user.authorizations.length).to eq(1)
      expect(User.count).to eq(1)
    end
 
    it 'should replace oauth credentials if reauthorizing the app' do
      newer_auth_hash = OmniAuth.config.mock_auth[:fitbit] = OmniAuth::AuthHash.new({
          :provider => 'fitbit',
          :uid => '123545',
          :credentials => {:token => '0000', :secret => '9999'}
      }) 

      @user = User.from_omniauth auth_hash, external_user
      expect(@user.authorizations.first.oauth_token).to eq (auth_hash['credentials']['token'])
      expect(@user.authorizations.first.oauth_secret).to eq (auth_hash['credentials']['secret'])
      @user = User.from_omniauth newer_auth_hash, external_user
      expect(@user.authorizations.first.oauth_token).to eq (newer_auth_hash['credentials']['token'])
      expect(@user.authorizations.first.oauth_secret).to eq (newer_auth_hash['credentials']['secret'])
    end 

    it 'should use the external_user attribute as the model username attribute' do
      @user = User.from_omniauth auth_hash, external_user
      expect(@user.username).to eq (external_user)
    end
   
  end

end
