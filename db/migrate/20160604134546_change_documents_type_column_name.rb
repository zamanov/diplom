class ChangeDocumentsTypeColumnName < ActiveRecord::Migration
  def change
    rename_column :documents, :type, :info
  end
end
