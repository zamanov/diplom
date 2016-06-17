class AddProgramRefToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :program, index: true, foreign_key: true
  end
end
