# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote(user)
    votes.find_by(user: user)
  end

  def voted?(user)
    vote(user).present?
  end

  def counter
    votes.sum(:action)
  end
end
