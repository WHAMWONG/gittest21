json.status 201
json.todo do
  json.id @todo.id
  json.title @todo.title
  json.description @todo.description
  json.due_date @todo.due_date.iso8601
  json.priority @todo.priority
  json.is_recurring @todo.is_recurring
  json.recurrence @todo.recurrence
  json.user_id @todo.user.id
  json.created_at @todo.created_at.iso8601
  json.updated_at @todo.updated_at.iso8601
  json.category_ids @todo.categories.pluck(:id) if @todo.categories.any?
  json.tag_ids @todo.tags.pluck(:id) if @todo.tags.any?
end
