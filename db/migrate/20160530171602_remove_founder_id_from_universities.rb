class RemoveFounderIdFromUniversities < ActiveRecord::Migration
  def change
    remove_column :universities, :founder_id
  end
end
