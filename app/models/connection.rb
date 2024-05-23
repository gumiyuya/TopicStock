class Connection < ApplicationRecord
  validates :topic_id, { presence: true, uniqueness: { scope: :similar_topic_id } }
  validates :similar_topic_id, { presence: true, uniqueness: { scope: :topic_id } }
  belongs_to :topic

  validate :validate_connections_count, on: :create
  validate :validate_different_topic_and_similar_topic

  private

  def validate_connections_count
    connections_count = Connection.where(topic_id: self.topic_id).count
    if connections_count >= 6
      errors.add(:base, "1つのトピックに紐づけられるトピックは6つまでです")
    end
  end

  def validate_different_topic_and_similar_topic
    if topic_id == similar_topic_id
      errors.add(:base, "同じトピック同士は紐づけられません")
    end
  end
end
