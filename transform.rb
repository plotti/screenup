require 'csv'

additional_data = {}
CSV.foreach("additional_data.csv") do |row|
	additional_data[row[0]] = {:new_name => row[1], :category => row[2]}
	additional_data[row[1]] = {:new_name => row[1], :category => row[2]}
end

CSV.open("transformed.csv", "wb") do |csv|
	csv << ["ID", "acategory"]
	CSV.foreach("twomode.csv") do |row|
		category = ""
		if additional_data[row[1]] != nil
			category = additional_data[row[1]][:category]
		else
			category = row[1]
		end
		csv << [row[0], category]
	end
end