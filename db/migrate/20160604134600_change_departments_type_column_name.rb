class ChangeDepartmentsTypeColumnName < ActiveRecord::Migration
  def change
    rename_column :departments, :type, :info
  end
end
