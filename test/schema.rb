ActiveRecord::Schema.define(:version => 0) do
  create_table :foos, :force => true do |t|
    t.boolean :no_homers
    t.string :status
    t.string :custom_status
    t.string :alternate_identification
    t.integer :bar_id
    t.integer :custom_bar_id    

    t.timestamps
  end
  create_table :bars, :force => true do |t|
    t.string :name

    t.timestamps
  end
  # This is the active table
  create_table :events, :force => true do |t|
    t.string   :eventable_type, :null => false
    t.integer  :eventable_id,   :null => false
    t.string   :field_name,     :null => false
    t.string   :whodunnit
    t.string   :message
    t.datetime :created_at
  end
end