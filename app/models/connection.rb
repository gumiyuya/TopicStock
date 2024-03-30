class Connection < ApplicationRecord
  validates :topic_id, { presence: true, uniqueness: { scope: :similar_topic_id } }
  validates :similar_topic_id, { presence: true, uniqueness: { scope: :topic_id } }
  belongs_to :topic
  belongs_to :similar_topic

  validate :validate_connections_count, on: :create

  private

  def validate_connections_count
    connections_count1 = Connection.where(topic_id: self.topic_id).count
    connections_count2 = Connection.where(similar_topic_id: self.similar_topic_id).count
    if connections_count1 >= 6 || connections_count2 >= 6
      errors.add(:base, "1つのトピックに紐づけられるトピックは6つまでです")
    end
  end
end
