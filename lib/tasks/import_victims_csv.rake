require 'csv'
namespace :import_victims_csv do
  task :create_victims => :environment do
    csv_text = File.read('public/seed_data/2013all.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
    	formatted_date = Date.strptime row[1], '%m/%d/%Y'
    	Victim.create!(date: formatted_date, age: row[5], name: row[8]) 
    end
  end
end