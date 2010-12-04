class AddConversationAccountRelationship < ActiveRecord::Migration
  def self.up
    create_table :conversations_accounts, :id => false do |t|
      t.integer  :account_id
      t.integer  :conversation_id
    end
  end

  def self.down
    drop_table :conversations_users
  end
end
