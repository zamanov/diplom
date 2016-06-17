class AddProfileToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :profile, :string
  end
end
