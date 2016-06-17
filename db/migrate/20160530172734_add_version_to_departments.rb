class AddVersionToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :version, :integer
  end
end
