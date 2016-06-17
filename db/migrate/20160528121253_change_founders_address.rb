class ChangeFoundersAddress < ActiveRecord::Migration
  def change
    change_column :founders, :address, :text
  end
end
