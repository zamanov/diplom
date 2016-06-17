class CreateUniversityInfos < ActiveRecord::Migration
  def change
    create_table :university_infos do |t|
      t.text :address
      t.text :fullname
      t.string :email
      t.date :regdate
      t.string :site
      t.string :telephone
      t.text :worktime
      t.text :founder_address
      t.string :founder_director
      t.string :founder_email
      t.string :founder_site
      t.string :founder_phone
      t.text :founder_name
      t.datetime :infodate
      t.belongs_to :university, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
