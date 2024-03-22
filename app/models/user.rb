class User < ApplicationRecord
  validates :name, {
    presence: true,
    uniqueness: true,
    length: { maximum: 12 }
  }
  validates :password, {
    presence: true,
    length: { minimum: 4, maximum: 12 },
    format: { with: /\A[a-zA-Z0-9]+\z/ }
  }
end