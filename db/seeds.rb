# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# This is fine for a file of this size, switch to streaming input for larger files
rushings_data = JSON.parse(File.read(Rails.root.join("rushing.json")))
imported = Import::RushingsImporter.import_list(rushings_data)
Rails.logger.info("Imported #{imported.size} rushing records from rushing.json")
