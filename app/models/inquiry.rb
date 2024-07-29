class Inquiry < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { email.present? }
  validates :message, presence: true, length: { maximum: 500 }
end
