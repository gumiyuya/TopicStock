class CreateConnections < ActiveRecord::Migration[7.1]
  def change
    create_table :connections do |t|
      t.integer :topic_id
      t.integer :s_topic_id

      t.timestamps
    end
  end
end
