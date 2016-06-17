people = Person.all
people.each do |person|
  if person.subjects.present?
    if person.subjects.first.university.name == "НИЯУ МИФИ"
      post = Post.find_or_create_by(person: person, placeable_type: 'University', placeable_id: 1, name: "Преподаватель")
      post.is_manage = false
      post.save
    end
  end
end
