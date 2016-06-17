class ChangeDocumentsType < ActiveRecord::Migration
  def change
    change_column :documents, :type, :text
  end
end
