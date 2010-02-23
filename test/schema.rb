ActiveRecord::Schema.define(:version => 0) do
  create_table :foos, :force => true do |t|
    t.boolean :no_homers
    t.string :status
    t.integer :bar_id

    t.timestamps
  end
  create_table :bars, :force => true do |t|
    t.string :name

    t.timestamps
  end
end