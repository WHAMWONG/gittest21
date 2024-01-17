class User < ApplicationRecord
  has_many :todos, dependent: :destroy

  # validations

  # end for validations

  class << self
  end
end
