# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :votable, polymorphic: true

  ACTION_LIST = [1, -1].freeze
end
