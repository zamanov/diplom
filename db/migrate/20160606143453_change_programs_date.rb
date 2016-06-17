class ChangeProgramsDate < ActiveRecord::Migration
  def change
    change_column :programs, :date, :string
  end
end
