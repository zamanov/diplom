class AddAccessDateToPeople < ActiveRecord::Migration
  def change
    add_column :people, :access_date, :datetime
  end
end
