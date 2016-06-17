class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :person, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
