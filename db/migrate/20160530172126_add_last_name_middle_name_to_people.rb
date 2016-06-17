class AddLastNameMiddleNameToPeople < ActiveRecord::Migration
  def change
    add_column :people, :middlename, :string
    add_column :people, :lastname, :string
  end
end
