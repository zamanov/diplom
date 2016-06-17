class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :code
      t.string :name
      t.string :form
      t.string :level
      t.date :date
      t.belongs_to :university, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
