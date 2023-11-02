# Authorization for Ability class for user actions

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(Admin)
      can :manage, Merchant
    end
  end
end
