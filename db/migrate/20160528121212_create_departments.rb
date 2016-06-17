class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.belongs_to :university, index: true, foreign_key: true
      t.text :address
      t.string :site
      t.string :email

      t.timestamps null: false
    end
  end
end
