# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedies = Category.create(name: 'TV Comedies')
dramas = Category.create(name: 'TV Dramas')
reality = Category.create(name: 'Reality TV')

Video.create(title: 'South Park',
             description: Faker::Lorem.paragraph,
             avatar: 'south_park.jpg',
             category: comedies)

monk = Video.create(title: 'Monk',
                    description: Faker::Lorem.paragraph,
                    avatar: 'monk.jpg',
                    img: 'monk_large.jpg',
                    category: dramas)

family_guy = Video.create(title: 'Family guy',
                          description: Faker::Lorem.paragraph,
                          avatar: 'family_guy.jpg',
                          category: reality)

Video.create(title: 'Futurama',
             description: Faker::Lorem.paragraph,
             avatar: 'futurama.jpg',
             category: comedies)

Video.create(title: 'South Park 2',
             description: Faker::Lorem.paragraph,
             avatar: 'south_park.jpg',
             category: comedies)

Video.create(title: 'Monk 2',
             description: Faker::Lorem.paragraph,
             avatar: 'monk.jpg',
             img: 'monk_large.jpg',
             category: dramas)

Video.create(title: 'Family guy 2',
             description: Faker::Lorem.paragraph,
             avatar: 'family_guy.jpg',
             category: reality)

Video.create(title: 'Futurama 2',
             description: Faker::Lorem.paragraph,
             avatar: 'futurama.jpg',
             category: comedies)

Video.create(title: 'South Park 3',
             description: Faker::Lorem.paragraph,
             avatar: 'south_park.jpg',
             category: comedies)

Video.create(title: 'Monk 3',
             description: Faker::Lorem.paragraph,
             avatar: 'monk.jpg',
             img: 'monk_large.jpg',
             category: dramas)

Video.create(title: 'Family guy 3',
             description: Faker::Lorem.paragraph,
             avatar: 'family_guy.jpg',
             category: reality)

Video.create(title: 'Futurama 3',
             description: Faker::Lorem.paragraph,
             avatar: 'futurama.jpg',
             category: comedies)

Video.create(title: 'One more comedy',
             description: Faker::Lorem.paragraph,
             avatar: 'futurama.jpg',
             category: comedies)


kati = User.create(email: 'golbang.k@gmail.com',
                   full_name: 'Kati Golbang',
                   password: '123',
                   password_confirmation: '123')
ramin = User.create(email: 'golbang.r@gmail.com',
                    full_name: 'Ramin Golbang',
                    password: '123',
                    password_confirmation: '123')

Review.create(content: Faker::Lorem.paragraph(3),
              rating: 5,
              video: monk,
              user: kati)
Review.create(content: Faker::Lorem.paragraph(3),
              rating: 2,
              video: monk,
              user: kati)

QueueItem.create(user: kati, video: monk, order_value: 1)
QueueItem.create(user: kati, video: family_guy, order_value: 2)