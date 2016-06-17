class AddCurrentVersionToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :current_version, :integer, :default => 1
  end
end
