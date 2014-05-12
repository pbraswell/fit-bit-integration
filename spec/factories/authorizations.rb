# == Schema Information
#
# Table name: authorizations
#
#  id           :integer          not null, primary key
#  provider     :string(255)
#  oauth_token  :string(255)
#  oauth_secret :string(255)
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authorization do
    provider "MyString"
    oauth_token "MyString"
    oauth_secret "MyString"
  end
end
