class Todo < ApplicationRecord
  has_many :todo_categories, dependent: :destroy
  has_many :todo_tags, dependent: :destroy
  has_many :attachments, dependent: :destroy

  belongs_to :user

  enum priority: %w[low medium high], _suffix: true
  enum recurrence: %w[daily weekly monthly], _suffix: true

  # validations rule 
  validates :due_date, presence: true, timeliness: { type: :datetime, on_or_after: lambda { Time.current }, message: I18n.t('activerecord.errors.messages.datetime_in_future') }
  validates :title, uniqueness: { scope: :user_id, message: I18n.t('activerecord.errors.messages.taken') }

  validate :validate_due_date_in_future

  # end for validations

  class << self
    def attach_files(todo_id, attachment_paths)
      todo = find(todo_id)
      attached_files = []

      attachment_paths.each do |file_path|
        if File.exist?(file_path) && File.readable?(file_path)
          attachment = todo.attachments.build(file_path: file_path)
          if attachment.save
            attached_files << attachment
          else
            return { error: "Failed to attach file: #{file_path}" }
          end
        else
          return { error: "File does not exist or is not accessible: #{file_path}" }
        end
      end

      attached_files
    end
  end

  private

  def validate_due_date_in_future
    errors.add(:due_date, I18n.t('activerecord.errors.messages.datetime_in_future')) if due_date.present? && due_date < Time.current
  end
end
