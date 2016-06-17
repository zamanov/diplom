class AddFileExtToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :file_ext, :string
  end
end
