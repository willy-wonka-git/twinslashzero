# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, User
    can :read, Post
    can :read, PostCategory
    can [:read, :search], Tag

    # permissions for users
    return unless user.present?

    can :create, Post
    can [:destroy, :archive], Post, author: user
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
    can :moderate, Post
    can :manage, PostCategory
    can :manage, Tag
  end
end
