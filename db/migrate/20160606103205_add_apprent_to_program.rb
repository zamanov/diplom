class AddApprentToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :apprent, :string
  end
end
