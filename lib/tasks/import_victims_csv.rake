require 'csv'
require 'mechanize'

namespace :import_victims_csv do

  task :create_victims => :environment do
    csv_text = File.read('public/seed_data/2013all.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
    	formatted_date = Date.strptime row[1], '%m/%d/%Y'
    	new_victim = Victim.find_or_initialize_by_name(row[8])
    	if (row[9] == 'Gunshot') && (row[8].present?)
    		new_victim.update_attributes(date: formatted_date, age: row[5], name: row[8], story_url: row[10])
    	end
    end

  end

  task :download_csv => :environment do
  	File.delete('public/seed_data/2013all.csv')
  	agent = Mechanize.new
  	agent.pluggable_parser.default = Mechanize::Download
  	agent.get('http://spreadsheets.google.com/pub?key=0Ak3IIavLYTovdHYxbDItQ255eWh1NzBiQXp5cmxRdmc&output=csv').save('public/seed_data/2013all.csv')
  end
end