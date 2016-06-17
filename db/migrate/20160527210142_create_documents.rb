class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.attachment :file
      t.string :code
      t.text :fullname
      t.belongs_to :university, index: true, foreign_key: true
      t.date :date
      t.string :type

      t.timestamps null: false
    end
  end
end
