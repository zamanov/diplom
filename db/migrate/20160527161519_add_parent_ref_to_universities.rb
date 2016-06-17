class AddParentRefToUniversities < ActiveRecord::Migration
  def change
    add_reference :universities, :parent, index: true
  end
end
