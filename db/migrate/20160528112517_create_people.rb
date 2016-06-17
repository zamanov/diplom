class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :degree
      t.string :rank
      t.integer :exp

      t.timestamps null: false
    end
  end
end
