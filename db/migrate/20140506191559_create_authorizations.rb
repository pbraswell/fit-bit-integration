class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :oauth_token
      t.string :oauth_secret
      t.belongs_to :user

      t.timestamps
    end
  end
end
