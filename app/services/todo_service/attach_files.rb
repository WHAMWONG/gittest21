class TodoService::AttachFiles < BaseService
  attr_reader :todo_id, :attachment_paths

  def initialize(todo_id:, attachment_paths:)
    @todo_id = todo_id
    @attachment_paths = attachment_paths
  end

  def call
    todo = Todo.find_by(id: todo_id)
    return { error: 'Todo not found' } unless todo

    attached_files = []
    attachment_paths.each do |file_path|
      if File.exist?(file_path) && File.readable?(file_path)
        attachment = todo.attachments.create(file_path: file_path)
        attached_files << attachment
      else
        return { error: "File #{file_path} is invalid or inaccessible" }
      end
    end

    { success: true, attached_files: attached_files.map { |attachment| attachment.attributes } }
  rescue StandardError => e
    { error: e.message }
  end
end

# Note: This service assumes that BaseService provides a common structure for service objects,
# including error handling. The File.exist? and File.readable? methods are used to check
# file validity and accessibility. The attributes method is called on the attachment to
# return its details.
