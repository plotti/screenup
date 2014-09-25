
require "rubygems"
require "sinatra"
require 'csv'
require 'json'

#class Screenup < Sinatra::Base

  get '/' do
    erb :index
  end

  get '/data.json' do
    edges = []
    tmp_nodes = []
    i = 0
    CSV.foreach("twomode.csv") do |row|
      i += 1
      edges << {:id => "e_#{i}", :source => "e_#{row[0].gsub(" ","")}", :target => "e_#{row[1].gsub(" ","")}"}
      tmp_nodes << row[0]
      tmp_nodes << row[1]
    end
    tmp_nodes.uniq
    nodes = []
    i = 0
    tmp_nodes.each do |node|
      i += 1
      nodes << {:id => "n_#{node.gsub(" ","")}", :label => "#{node.gsub(" ","")}", :size => 3}
    end
    content_type :json
    @data = {"nodes" => nodes, "edges" => edges}.to_json#
  end

#end

