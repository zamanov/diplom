class Post < ActiveRecord::Base
  belongs_to :person
  belongs_to :placeable, :polymorphic => true
  scope :ordering, -> { (order(:name)) }


  def self.search(search)
    where("name ILIKE ?", "%#{search}%")
  end

end
