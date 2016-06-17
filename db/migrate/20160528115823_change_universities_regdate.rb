class ChangeUniversitiesRegdate < ActiveRecord::Migration
  def change
    change_column :universities, :regdate, :date
  end
end
