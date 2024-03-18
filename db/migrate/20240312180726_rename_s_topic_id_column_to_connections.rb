class RenameSTopicIdColumnToConnections < ActiveRecord::Migration[7.1]
  def change
    rename_column :connections, :s_topic_id, :similar_topic_id
  end
end
