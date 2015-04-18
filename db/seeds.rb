# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: 'TV Comedies')
Category.create(name: 'TV Dramas')
Category.create(name: 'Reality TV')

Video.create(title: 'South Park', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'south_park.jpg', category: Category.find(1))

Video.create(title: 'Monk', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'monk.jpg', img: 'monk_large.jpg', category: Category.find(2))

Video.create(title: 'Family guy', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'family_guy.jpg', category: Category.find(3))

Video.create(title: 'Futurama', description: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
             avatar: 'futurama.jpg', category: Category.find(1))