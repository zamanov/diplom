class Person < ActiveRecord::Base
  has_many :subjects
  has_many :posts
  scope :ordering, -> { (order(:lastname)) }

  def to_fullname
    "#{lastname} #{name} #{middlename}"
  end
end
