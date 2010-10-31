class CreateConnections < ActiveRecord::Migration
  def self.up
    create_table :connections do |t|
      t.string   :type
      t.integer  :user_id
      t.integer  :connection_id
      t.timestamps
    end
  end

  def self.down
    drop_table :connections
  end
end
