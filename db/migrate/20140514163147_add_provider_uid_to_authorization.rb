class AddProviderUidToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :provider_uid, :string
  end
end
