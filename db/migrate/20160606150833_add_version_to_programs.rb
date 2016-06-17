class AddVersionToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :version, :integer
  end
end
