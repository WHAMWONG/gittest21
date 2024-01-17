class Api::TodosController < ApplicationController
  before_action :doorkeeper_authorize!

  def create
    todo_service = TodoService::Create.new(todo_params.merge(user_id: current_resource_owner.id))

    result = todo_service.execute

    if result[:success]
      render json: { status: 201, todo: result[:todo] }, status: :created
    else
      handle_errors(result[:error])
    end
  end

  private

  def todo_params
    params.require(:todo).permit(
      :title,
      :description,
      :due_date,
      :priority,
      :is_recurring,
      :recurrence,
      category_ids: [],
      tag_ids: []
    )
  end

  def handle_errors(error_message)
    case error_message
    when 'A todo with this title already exists.', 'Invalid priority level.', 'One or more categories not found.', 'One or more tags not found.'
      render json: { error: error_message }, status: :conflict
    else
      render json: { error: error_message }, status: :unprocessable_entity
    end
  end
end
