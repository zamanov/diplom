class AddIsManageToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_manage, :boolean
  end
end
