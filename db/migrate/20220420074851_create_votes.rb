# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.belongs_to :votable, polymorphic: true
      t.integer :action, null: false
      t.timestamps
    end
  end
end
