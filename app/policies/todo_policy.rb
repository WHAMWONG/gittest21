class TodoPolicy
  attr_reader :user, :todo

  def initialize(user, todo)
    @user = user
    @todo = todo
  end

  # This method checks if a user is allowed to create a todo.
  def create?
    user.present?
  end

  # This method checks if the current user is allowed to attach a todo.
  def attach?
    todo.user_id == user.id
  end
end
