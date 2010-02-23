class TrackableMigration < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string   :eventable_type, :null => false
      t.integer  :eventable_id,   :null => false
      t.string   :field_name,     :null => false
      t.string   :whodunnit
      t.string   :message
      t.datetime :created_at
    end
    add_index :events, [:eventable_id, :eventable_type, :field_name]
  end

  def self.down
    drop_table :events
  end
end