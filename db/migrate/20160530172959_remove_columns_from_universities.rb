class RemoveColumnsFromUniversities < ActiveRecord::Migration
  def change
    remove_column :universities, :address
    remove_column :universities, :email
    remove_column :universities, :fullname
    remove_column :universities, :regdate
    remove_column :universities, :telephone
    remove_column :universities, :worktime
    remove_column :universities, :site
  end
end
