class Product < ApplicationRecord
  include Notifications

  has_rich_text :description
  has_one_attached :contract, service: :lob

  has_one :counter, class_name: "ProductCounter", dependent: :destroy

  has_many :comments,  -> { order(created_at: :asc) }, dependent: :destroy
  has_many :subscribers, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }
end
