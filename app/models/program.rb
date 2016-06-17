class Program < ActiveRecord::Base
  belongs_to :university
  has_many :documents
  scope :ordering, -> { (order(:name)) }

end
