class ChangeDocumentsDate < ActiveRecord::Migration
  def change
    change_column :documents, :date, :datetime
  end
end
