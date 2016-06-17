class AddVersionToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :version, :integer
  end
end
