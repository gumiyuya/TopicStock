class Topic < ApplicationRecord
  validates :content, { presence: true, length: { maximum: 40 } }
  validates :user_id, uniqueness: { scope: :content }
  has_many :connections
  has_many :s_topics, through: :connections
end