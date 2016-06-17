class AddTypeToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :type, :string
  end
end
