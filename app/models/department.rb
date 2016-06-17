class Department < ActiveRecord::Base
  belongs_to :university
  belongs_to :head, class_name: "Department"
  has_many :branches, class_name: "Department", foreign_key: "head_id"
  has_many :posts, :as => :placeable
  scope :ordering, -> { (order(:name)) }
end
