require 'csv'
require 'mechanize'
require 'twitter'

namespace :import_victims_csv do

  task :create_victims => :environment do

  	# Delete the old seed data if it exists
  	File.delete('public/seed_data/2013all.csv') if File.exist?('public/seed_data/2013all.csv')

  	# Use Mechanize to download the new csv from the red eye google spreadsheet
  	agent = Mechanize.new
  	agent.pluggable_parser.default = Mechanize::Download
  	agent.get('http://spreadsheets.google.com/pub?key=0Ak3IIavLYTovdHYxbDItQ255eWh1NzBiQXp5cmxRdmc&output=csv').save('public/seed_data/2013all.csv')

    csv_text = File.read('public/seed_data/2013all.csv')
    csv = CSV.parse(csv_text, :headers => true)

    csv.each do |row|

    	# Test if cause of death was a gunshot and if there is a name, otherwise ignore row
    	if (row[9] == 'Gunshot') && (row[8].present?)

    		# Format the date into ruby-friendly format
	    	formatted_date = Date.strptime row[1], '%m/%d/%Y'

	    	# Find or intialize by name
	    	new_victim = Victim.find_or_initialize_by_name(row[8])

	    	# Test to see if the name was initialized, if so it's a new victim and should be tweeted
	    	if (new_victim.id.blank?)
	    		Twitter.update("#{row[8]} #{row[5]} #{row[10]}")
	    	end

    	
    		new_victim.update_attributes(date: formatted_date, age: row[5], name: row[8], story_url: row[10])
    	end

    end

  end

end