class Ability
  include CanCan::Ability

  

  def initialize(user)

    can :index, Post

    indexable_condition = <<-EOC
    restricted = ? OR post.user_id = ? OR
      (restricted = ? AND EXISTS 
        (SELECT * FROM collaborations WHERE 
          collaborations.post_id = posts.id AND 
          collaborations.user_id = ?))
    EOC

    editable_condition = <<-EOC
    post.user_id = ? OR
      (restricted = ? AND EXISTS 
        (SELECT * FROM collaborations WHERE 
          collaborations.post_id = posts.id AND 
          collaborations.user_id = ?))
    EOC

    # if user is logged in
    if user && user.persisted?
      # he cannot destroy posts
      # cannot :destroy, Post
      # he can destroy posts with his user id
      can :destroy, Post, user_id: user.id

      can :show, Post, [indexable_condition, false, user.id, true, user.id] do |post|
        !post.restricted? || post.user_id == user.id ||
          (post.restricted? && post.collaborations.where(user_id: user.id).present?)
      end
      can [:edit, :update], Post, [editable_condition, false, user.id, true, user.id] do |post|
        post.user_id == user.id ||
          (post.restricted? && post.collaborations.where(user_id: user.id).present?)
      end

    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
