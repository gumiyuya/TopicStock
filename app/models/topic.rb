class Topic < ApplicationRecord
  validates :content, {
    presence: true,
    length: { maximum: 40 },
    format: { without: /\n/ }
  }
  validates :user_id, uniqueness: { scope: :content }
  belongs_to :user
  has_many :connections, dependent: :destroy

  validate :not_blank

  private

  def not_blank
    if content.strip.empty?
      errors.add(:base, "空白のトピックは登録できません")
    end
  end
end