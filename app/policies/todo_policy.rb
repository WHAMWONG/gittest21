class TodoPolicy
  attr_reader :user, :todo

  def initialize(user, todo)
    @user = user
    @todo = todo
  end

  def create?
    user.present?
  end
end
