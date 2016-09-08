class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def index?
    true
  end

  def isanimalsedit?
    @current_user.animals_edit?
  end

  def isadoptersedit?
    @current_user.adopters_edit?
  end

  def isdefaultuser?
    @current_user.default_user?
  end
end
