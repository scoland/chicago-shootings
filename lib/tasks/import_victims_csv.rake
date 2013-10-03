require 'csv'
namespace :import_victims_csv do
  task :create_victims => :environment do
    csv_text = File.read('public/seed_data/2013all.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
    	Victim.create!(date: row[1], age: row[5], name: row[8]) 
    end
  end
end