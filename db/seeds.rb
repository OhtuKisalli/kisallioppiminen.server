# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Course.create(coursekey: 'testikurssiavain', name: 'Testikurssi')

Exercise.create(html_id: "may1;1.1", course_id: 1)
Exercise.create(html_id: "may1;1.2", course_id: 1)
Exercise.create(html_id: "may1;1.3", course_id: 1)
Exercise.create(html_id: "may1;1.4", course_id: 1)
Exercise.create(html_id: "may1;1.5", course_id: 1)
Exercise.create(html_id: "may1;1.6", course_id: 1)
Exercise.create(html_id: "may1;1.7", course_id: 1)
Exercise.create(html_id: "may1;1.8", course_id: 1)
Exercise.create(html_id: "may1;1.9", course_id: 1)
Exercise.create(html_id: "may1;1.10", course_id: 1)

Checkmark.create(user_id: 1, exercise_id: 2, status: "green")
Checkmark.create(user_id: 1, exercise_id: 3, status: "red")
Checkmark.create(user_id: 1, exercise_id: 4, status: "yellow")