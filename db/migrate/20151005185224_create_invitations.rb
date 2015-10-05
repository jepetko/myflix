class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string :name
      t.string :email
      t.string :token
      t.timestamps
    end
  end
end
