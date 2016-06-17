class AddVersionToUniversityInfos < ActiveRecord::Migration
  def change
    add_column :university_infos, :version, :integer
  end
end
