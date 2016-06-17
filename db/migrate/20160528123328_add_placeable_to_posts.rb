class AddPlaceableToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :placeable, polymorphic: true, index: true
  end
end
