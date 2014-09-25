require 'csv'

additional_data = {}
CSV.foreach("additional_data.csv") do |row|
	additional_data[row[0]] = {:new_name => row[1], :category => row[2]}
	additional_data[row[1]] = {:new_name => row[1], :category => row[2]}
end

color_table = {"Andere" => 15, "ScreenUp" => 1, "Kunde" => 2, "Print" => 3, "Agentur" =>4, "Broadcaster" => 5, 
		 "Intelligence" => 6, "Infrastruktur" => 7, "HR" => 8, "Verband" => 9, "Produktion" => 10, 
		 "Kino" => 11, "Werbevermarkter" => 12, "Radio" => 13, "Forschung" => 14}

CSV.open("transformed.csv", "wb") do |csv|
	csv << ["ID", "acategory", "color"]
	CSV.foreach("twomode.csv") do |row|
		category = ""
		if additional_data[row[1]] != nil
			category = additional_data[row[1]][:category]
		else
			category = row[1]
		end
		color = color_table[category]
		if color == nil
			color = 0
		end
		csv << [row[0], category, color]
	end
end