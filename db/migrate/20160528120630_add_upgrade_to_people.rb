class AddUpgradeToPeople < ActiveRecord::Migration
  def change
    add_column :people, :upgrade, :text
  end
end
