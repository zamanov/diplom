class AddAccessDateToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :access_date, :datetime
  end
end
