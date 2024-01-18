
class Attachment < ApplicationRecord
  belongs_to :todo

  # validations
  validates_presence_of :file_path
  validates_uniqueness_of :file_path
  # end for validations

  class << self
  end
end
