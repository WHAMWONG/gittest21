class TodoCategory < ApplicationRecord
  belongs_to :todo
  belongs_to :category

  # validations

  # end for validations

  class << self
  end
end
