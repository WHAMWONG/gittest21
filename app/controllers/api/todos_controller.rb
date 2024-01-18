
class Api::TodosController < ApplicationController
  # Removed require_dependency as Rails autoloads constants, using TodoService::Create and TodoPolicy for creation logic

  before_action :doorkeeper_authorize!

  def create
    todo_service = TodoService::Create.new(todo_params.merge(user_id: current_resource_owner.id)) # Use the service object for creation logic

    result = todo_service.execute
    authorize Todo.new, policy_class: TodoPolicy # Authorize user for create action using TodoPolicy

    if result[:success]
      render json: { status: 201, todo: result[:todo] }, status: :created
    else
      handle_errors(result[:error])
    end # Handle success and error responses
  end
  # ... other actions in the controller ...

  private

  def todo_params
    params.require(:todo).permit(
      :title,
      :description, # Permitting the required and optional parameters
      :due_date,
      :priority,
      :is_recurring, # Permitting recurrence and category/tag ids
      :recurrence,
      category_ids: [],
      tag_ids: []
    )
  end # Strong parameters for todo creation

  def handle_errors(error_message)
    case error_message # Handle different error messages and statuses
    when 'A todo with this title already exists.', 'Invalid priority level.', 'One or more categories not found.', 'One or more tags not found.'
      render json: { error: error_message }, status: :conflict
    else
      render json: { error: error_message }, status: :unprocessable_entity
    end
  end # Error handling based on the error message

  # ... other actions in the controller ...
end
