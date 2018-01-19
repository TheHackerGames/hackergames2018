# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

civilian1 = User.create!(name: 'Bob', email: 'test1@carwow.co.uk', password: 'carwow', avatar_url: 'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50')
civilian2 = User.create!(name: 'Alice', email: 'test2@carwow.co.uk', password: 'carwow', avatar_url: 'https://i.pinimg.com/736x/73/ce/df/73cedf58e92a0b59432691b2a7d460ea--avatar-opera.jpg')
vet = User.create!(name: 'George', email: 'test3@carwow.co.uk', password: 'carwow', avatar_url: 'https://i.pinimg.com/736x/ce/b4/cc/ceb4cc5bd4c8b9937a3ff4fb12ad1dba--linux-avatar.jpg')

availabilities = [
  Availability.create!(user_id: civilian1.id, name: "Starbucks Coffee", address: "30 Upper St, Islington, London N1 0PN, UK",
    latitude: 51.5345266, longitude: -0.105305300000055, gmaps_place_id: "ChIJQUtcSF0bdkgRUVUa-rIA7FI",
    start_datetime: "2018-01-18 18:12:22", end_datetime: "2018-01-18 19:12:22"
  ),
  Availability.create!(user_id: civilian2.id, name: "Costa Coffee", address: "26-30 York Way, Kings Cross, London N1 9AA, UK",
    latitude: 51.5320274, longitude: -0.122163, gmaps_place_id: "ChIJo042sT4bdkgRbjY71WTYc94",
    start_datetime: "2018-01-18 18:10:39", end_datetime: "2018-01-18 19:13:39"
  )
]