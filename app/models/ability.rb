# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :show, User
    can :read, Post, aasm_state: "published"
    can :read, PostCategory
    can [:read, :search], Tag

    # permissions for users
    return if user.blank?

    can :index, User
    can :create, Post
    can [:destroy, :archive], Post, author: user
    can :read, Post, author: user
    can :update, Post, author: user, aasm_state: "draft"
    can [:run, :draft, :archive], Post, author: user
    can :create, Tag

    # permissions for administrators
    return unless user.admin?

    can :manage, User
    cannot :destroy, User, id: user.id
    cannot [:create, :update], Post
    can :destroy, Post
    can [:reject, :ban, :approve, :publish, :archive, :draft], Post
    can :read, Post
    can :moderate, Post
    can :action, Post
    can :manage, PostCategory
    can :manage, Tag
  end
end
