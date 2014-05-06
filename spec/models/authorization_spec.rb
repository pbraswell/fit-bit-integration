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

require 'spec_helper'

describe Authorization do
  pending "add some examples to (or delete) #{__FILE__}"
end
