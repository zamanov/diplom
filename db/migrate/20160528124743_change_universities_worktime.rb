class ChangeUniversitiesWorktime < ActiveRecord::Migration
  def change
    change_column :universities, :worktime, :text
  end
end
