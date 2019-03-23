class Item < ApplicationRecord
  belongs_to :thing
  belongs_to :item_type
  has_many :links
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { in: 8..120 }
  validates :item_type, presence: true
  validates :thing, presence: true
end