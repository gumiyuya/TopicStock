class AddUserIdToTopics < ActiveRecord::Migration[7.1]
  def change
    add_column :topics, :user_id, :integer
  end
end
