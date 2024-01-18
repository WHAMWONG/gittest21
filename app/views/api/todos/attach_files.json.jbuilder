json.status 201
json.attachment do
  json.id @attachment.id
  json.todo_id @attachment.todo_id
  json.file_path @attachment.file_path
  json.created_at @attachment.created_at.iso8601
end
