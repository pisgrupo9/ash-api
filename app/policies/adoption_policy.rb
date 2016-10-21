class AdoptionPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def create?
    @current_user.adopters_edit? || @current_user.super_user?
  end

  def destroy?
    @current_user.adopters_edit? || @current_user.super_user?
  end
end
