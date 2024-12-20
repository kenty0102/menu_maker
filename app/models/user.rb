class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :recipes, dependent: :destroy
  has_many :menus, dependent: :destroy
  has_many :authentications, dependent: :destroy

  accepts_nested_attributes_for :authentications

  attr_accessor :current_password, :skip_password_validation

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true, if: -> { email.present? }
  validates :password, length: { minimum: 4 }, if: -> { (new_record? || changes[:crypted_password]) && !skip_password_validation }
  validates :password, confirmation: true, if: -> { (new_record? || changes[:crypted_password]) && !skip_password_validation }
  validates :password_confirmation, presence: true, if: -> { (new_record? || changes[:crypted_password]) && !skip_password_validation }
  validates :reset_password_token, uniqueness: true, allow_nil: true
end
