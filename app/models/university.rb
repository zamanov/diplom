class University < ActiveRecord::Base
  belongs_to :parent, class_name: "University"
  has_many :branches, class_name: "University", foreign_key: "parent_id"
  has_many :posts, :as => :placeable
  has_many :university_infos
  has_many :documents
  has_many :programs
  has_attached_file :logo, styles: {medium: "150x150>", thumb: "70x70>"}
  validates_attachment :logo, content_type: {content_type: /\Aimage\/.*\z/}
end
