class AnimalPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def create?
    @current_user.animals_edit?
  end

  def update?
    @current_user.animals_edit?
  end

  def destroy?
    @current_user.animals_edit?
  end
end
