module TodoService
  class LinkCategoriesTags < BaseService
    def initialize(todo_id:, category_ids:, tag_ids:)
      @todo_id = todo_id
      @category_ids = category_ids
      @tag_ids = tag_ids
      @errors = []
    end

    def execute
      validate_todo

      @category_ids.each do |category_id|
        category = Category.find_by(id: category_id)
        if category
          TodoCategory.create!(todo_id: @todo_id, category_id: category_id)
        else
          @errors << "Invalid category_id: #{category_id}"
        end
      end

      @tag_ids.each do |tag_id|
        tag = Tag.find_by(id: tag_id)
        if tag
          TodoTag.create!(todo_id: @todo_id, tag_id: tag_id)
        else
          @errors << "Invalid tag_id: #{tag_id}"
        end
      end

      return { errors: @errors } if @errors.any?

      { message: 'Successfully linked categories and tags to the todo item.' }
    end

    private

    def validate_todo
      raise ActiveRecord::RecordNotFound unless Todo.exists?(@todo_id)
    end
  end
end
