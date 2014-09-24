require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require "google-search"

url = "http://www.screen-up.ch/teilnehmer"

doc = Nokogiri::HTML(open(url))
get_lastname = false
get_company = false
skip = false
companies = []
firstname, lastname, company = "","",""
additional_data = {}

CSV.foreach("additional_data.csv") do |row|
	additional_data[row[0]] = {:new_name => row[1], :category => row[2]}
end

CSV.open("twomode.csv", "wb") do |csv|
	csv << ["Source", "Target", "Weight"]
	CSV.foreach("baseline_data.csv") do |row|
		csv << row.collect{|r| r.gsub(" "," ")}
	end
	doc.css("div.container section").children.each do |child|
		if child.name == "strong"
			firstname = child.text
			get_lastname = true
			next
		end
		if get_lastname
			lastname = child.text
			skip = true
			get_lastname = false
			next
		end
		if skip
			get_company = true
			skip = false
			next
		end
		if get_company
			child = child.text.gsub("\r\n","")
			begin child.length > 0
				company = additional_data[child][:new_name]
				category = additional_data[child][:category]
			rescue
				category = "Andere"
				company = "Keine Angaben"
			end
			csv << ["#{firstname} #{lastname}", "#{company}", 1]
			csv << [company, category, 1]
			get_company = false
		end	
	end
end


