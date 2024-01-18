require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'

  # ... other routes ...

  # New route from the new code
  post '/api/v1/todos/:todo_id/attachments', to: 'todos#attach_files'

  # Existing route from the existing code
  post '/api/v1/todos', to: 'todos#create'
end
