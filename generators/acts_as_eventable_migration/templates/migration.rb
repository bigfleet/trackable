class ActsAsEventableMigration < ActiveRecord::Migration
  def self.up
    create_table :event_types do |t|
      t.string :name
    end

    create_table :events do |t|
      t.integer :eventable_id, :default => 0, :null => false
      t.string :eventable_type, :limit => 25, :default => "", :null => false
      t.integer :event_type_id

      t.timestamps
    end
    add_index :events, [:eventable_id, :eventable_type]  
    add_index :events, :event_type_id
  end

  def self.down
    drop_table :events
    drop_table :event_types
  end
end