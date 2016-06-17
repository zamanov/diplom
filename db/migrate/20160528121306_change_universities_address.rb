class ChangeUniversitiesAddress < ActiveRecord::Migration
  def change
    change_column :universities, :address, :text
  end
end
