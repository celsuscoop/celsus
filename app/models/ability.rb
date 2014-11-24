class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :crud
    can :read, [Content, Post]
    if user
      if user.su?
        can :manage, :all
      elsif user.admin?
        can :manage, [Content, Warning, Post, Category]
        can :read, [User]
      elsif user.contributor?
        can :crud, [Content], :user_id => user.id
        can :create, [Content]
        can :download, [Content]
      else
        can :create, Content
        can :download, Content
      end
    end
  end
end