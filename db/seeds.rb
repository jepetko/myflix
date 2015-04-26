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

Video.create(title: 'South Park', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'south_park.jpg', category: comedies)

Video.create(title: 'Monk', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'monk.jpg', img: 'monk_large.jpg', category: dramas)

Video.create(title: 'Family guy', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'family_guy.jpg', category: reality)

Video.create(title: 'Futurama', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'futurama.jpg', category: comedies)

Video.create(title: 'South Park 2', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'south_park.jpg', category: comedies)

Video.create(title: 'Monk 2', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'monk.jpg', img: 'monk_large.jpg', category: dramas)

Video.create(title: 'Family guy 2', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'family_guy.jpg', category: reality)

Video.create(title: 'Futurama 2', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'futurama.jpg', category: comedies)

Video.create(title: 'South Park 3', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'south_park.jpg', category: comedies)

Video.create(title: 'Monk 3', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'monk.jpg', img: 'monk_large.jpg', category: dramas)

Video.create(title: 'Family guy 3', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'family_guy.jpg', category: reality)

Video.create(title: 'Futurama 3', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'futurama.jpg', category: comedies)

Video.create(title: 'One more comedy', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'futurama.jpg', category: comedies)


User.create(email: 'golbang.k@gmail.com', full_name: 'Kati Golbang', password: '123', password_confirmation: '123')
User.create(email: 'golbang.r@gmail.com', full_name: 'Ramin Golbang', password: '123', password_confirmation: '123')