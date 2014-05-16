require 'spec_helper'

describe AuthorizationController do

  describe "GET 'is_linked'" do

    let!(:user) {FactoryGirl.create :user}
    before :each do
      @request.env["HTTP_ACCEPT"] = "application/json"
    end

    it 'returns http success' do
      get :is_linked, id: user.id
      expect(response).to be_success
    end

    it 'returns true if user is linked' do
      @expected = {:linked => true}.to_json
      get :is_linked, id: user.username
      expect(response.body).to eq @expected
    end

    it 'returns false if the user is not linked' do
      @expected = {:linked => false}.to_json
      get :is_linked, id: 9999
      expect(response.body).to eq @expected 
    end 

  end

end 
 
