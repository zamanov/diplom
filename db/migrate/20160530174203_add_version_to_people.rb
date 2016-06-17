class AddVersionToPeople < ActiveRecord::Migration
  def change
    add_column :people, :version, :integer
  end
end
