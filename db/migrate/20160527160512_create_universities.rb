class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities do |t|
      t.string :name
      t.string :fullname
      t.date :regdate
      t.string :address
      t.string :worktime
      t.string :telephone
      t.string :site
      t.string :email
      t.belongs_to :founder, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
