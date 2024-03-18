class SimilarTopic < ApplicationRecord
  validates :content, { presence: true, length: { maximum: 40 } }
  validates :user_id, uniqueness: { scope: :content }
  has_many :connections
  has_many :topics, through: :connections
end
