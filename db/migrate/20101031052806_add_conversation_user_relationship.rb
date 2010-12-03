class AddConversationUserRelationship < ActiveRecord::Migration
  def self.up
    create_table :conversations_users, :id => false do |t|
      t.integer  :person_id
      t.integer  :conversation_id
    end
  end

  def self.down
    drop_table :conversations_users
  end
end
