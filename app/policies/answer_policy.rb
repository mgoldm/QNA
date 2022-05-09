# frozen_string_literal: true

class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.admin? || user == record.user
  end

  def update_best?
    user == record.question.user
  end

  def destroy?
    user == record.user
  end
end
