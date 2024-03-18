class CreateSimilarTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :similar_topics do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
