class Book < ApplicationRecord
  belongs_to :user

  validates :title
end
