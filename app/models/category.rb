class Category < ApplicationRecord
  has_many :todo_categories, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
