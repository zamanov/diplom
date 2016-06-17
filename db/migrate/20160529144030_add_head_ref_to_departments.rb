class AddHeadRefToDepartments < ActiveRecord::Migration
  def change
    add_reference :departments, :head, index: true
  end
end
