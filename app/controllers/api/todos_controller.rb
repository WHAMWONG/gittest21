class Api::TodosController < ApplicationController
  require_dependency 'app/models/todo'
  require_dependency 'app/models/attachment'
  require_dependency 'app/services/todo_service/attach_files'
  require_dependency 'app/policies/application_policy'

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

  def attach_files
    todo_id = params[:todo_id]
    file_path = params[:file_path]

    return render json: { error: "File path is required." }, status: :bad_request if file_path.blank?

    todo = Todo.find_by(id: todo_id)
    return render json: { error: "Todo item not found." }, status: :not_found unless todo

    authorize todo, policy_class: ApplicationPolicy

    result = TodoService::AttachFiles.new(todo_id: todo_id, attachment_paths: [file_path]).call

    if result[:error]
      render json: { error: result[:error] }, status: :unprocessable_entity
    else
      attachment = result[:attached_files].first
      render json: {
        status: 201,
        attachment: {
          id: attachment['id'],
          todo_id: attachment['todo_id'],
          file_path: attachment['file_path'],
          created_at: attachment['created_at'].iso8601
        }
      }, status: :created
    end
  rescue Pundit::NotAuthorizedError
    render json: { error: "User does not have permission to access the specified todo item." }, status: :forbidden
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

  # ... other actions in the controller ...
end
