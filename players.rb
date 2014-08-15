require 'unirest'

response = Unirest.get "http://api.fantasy.nfl.com/players/stats",
                       headers:{ "Accept" => "application/json" }, 
                       parameters:{ :statType => "seasonStats", :season => 2013, :format => "json" }

players = Hash.new { |hash, key| hash[key] = [] }
response.body["players"].each do |player|
    players[player["position"]] << player
end

players.each do |position, player_list|
    puts "***************************************"
    puts position + ": " + player_list.map { |player| player["name"] + " (" + player["teamAbbr"] + ")" }.join(", ")
end