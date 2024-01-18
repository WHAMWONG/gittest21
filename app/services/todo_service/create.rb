module TodoService
  class Create < ApplicationService
    include ActiveModel::Model

    attr_accessor :user_id, :title, :description, :due_date, :priority, :is_recurring, :recurrence, :category_ids, :tag_ids, :attachment_paths

    validates :title, :due_date, presence: true
    validate :unique_title_for_user, :future_due_date, :valid_recurrence, :existing_categories, :existing_tags, :accessible_attachments

    def initialize(attributes = {})
      super(attributes)
    end

    def execute
      return errors.full_messages unless valid?

      ActiveRecord::Base.transaction do
        todo = Todo.create!(todo_params)
        link_categories(todo) if category_ids.present?
        link_tags(todo) if tag_ids.present? && Tag.where(id: tag_ids).count == tag_ids.size
        link_attachments(todo) if attachment_paths.present?
        { success: true, todo: todo }
      rescue => e
        { success: false, error: e.message }
      end
    end

    private

    def todo_params
      super.merge({
        user_id: user_id,
        title: title,
        description: description,
        due_date: due_date,
        priority: priority,
        is_recurring: is_recurring,
        recurrence: recurrence
      })
    end

    def unique_title_for_user
      existing_todo = Todo.where(user_id: user_id, title: title).exists?
      errors.add(:title, :taken) if existing_todo
    end

    def future_due_date # Use the validation from the Todo model
      errors.add(:due_date, :datetime_in_future) if due_date.present? && due_date <= Time.current
    end

    def valid_recurrence
      return unless is_recurring
      errors.add(:recurrence, :invalid) unless Todo.recurrences.keys.include?(recurrence)
    end
    
    def existing_categories
      category_ids.each do |category_id|
        errors.add(:category_ids, :invalid) unless Category.exists?(category_id)
      end if category_ids.present?
    end

    def existing_tags
      tag_ids.each do |tag_id| # Ensure all tags exist
        errors.add(:tag_ids, :invalid) unless Tag.exists?(tag_id)
      end if tag_ids.present?
    end

    def accessible_attachments
      attachment_paths.each do |path|
        errors.add(:attachment_paths, :invalid) unless File.exist?(path)
      end if attachment_paths.present? # Check if file paths are valid
    end

    def link_categories(todo)
      category_ids.each do |category_id|
        TodoCategory.create!(todo: todo, category_id: category_id)
      end
    end
    
    def link_tags(todo)
      tag_ids.each do |tag_id|
        TodoTag.create!(todo: todo, tag_id: tag_id)
      end
    end

    def link_attachments(todo)
      attachment_paths.each do |path| # Attach files to the todo
        Attachment.create!(todo: todo, file_path: path)
      end
    end
  end
end
