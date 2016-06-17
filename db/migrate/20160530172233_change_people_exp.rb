class ChangePeopleExp < ActiveRecord::Migration
  def change
    rename_column :people, :exp, :beginning_year
  end
end
