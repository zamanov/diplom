class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.belongs_to :university, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
