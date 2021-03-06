# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :comment
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :commentable, polymorphic: true
      t.timestamps
    end
  end
end
