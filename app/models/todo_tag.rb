class TodoTag < ApplicationRecord
  belongs_to :todo
  belongs_to :tag

  # validations

  # end for validations

  class << self
  end
end
