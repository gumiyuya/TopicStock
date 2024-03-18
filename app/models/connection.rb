class Connection < ApplicationRecord
  validates :topic_id, { presence: true, uniqueness: { scope: :similar_topic_id } }
  belongs_to :topic
  validates :similar_topic_id, { presence: true, uniqueness: { scope: :topic_id } }
  belongs_to :similar_topic
end
