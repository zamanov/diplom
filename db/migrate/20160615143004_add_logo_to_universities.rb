class AddLogoToUniversities < ActiveRecord::Migration
  def change
    add_attachment :universities, :logo
  end
end
