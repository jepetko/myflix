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