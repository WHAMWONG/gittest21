class Tag < ApplicationRecord
  has_many :todo_tags, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
