class ChangeProgramsName < ActiveRecord::Migration
  def change
    change_column :programs, :name, :text
  end
end
