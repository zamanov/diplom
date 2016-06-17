class ChangeUniversityInfosRegdate < ActiveRecord::Migration
  def change
    change_column :university_infos, :regdate, :string
  end
end
