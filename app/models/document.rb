class Document < ActiveRecord::Base
  belongs_to :university
  belongs_to :program
  has_attached_file :file
  validates_attachment_content_type :file, :content_type => /application/
  scope :ordering, -> { (order(:fullname)) }

end
