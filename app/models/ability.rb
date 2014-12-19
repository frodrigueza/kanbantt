class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
   
    #se asignan los permisos
    if user.role == "super_admin"
        can :manage, :all
    elsif user.role == "admin"
        can :manage, :all
        cannot [:create], Project
        cannot [:update, :destroy], User, role: "super_admin"
        cannot [:update, :destroy], User, role: "admin"

    elsif user.role == "last_planner"
        can :manage, :all
        cannot [:create, :update, :destroy], [User,Project]
        cannot [:destroy], [Task]
        can :update, User, id: user.id
    
    elsif user.role == "observer"
        can :read, :all
    end

  end
end
