class AddPersonRefToSubjects < ActiveRecord::Migration
  def change
    add_reference :subjects, :person, index: true, foreign_key: true
  end
end
