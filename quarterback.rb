require 'unirest'

class Quarterback
    attr_accessor :name, :att, :comp, :yards, :teamAbbr, :tds, :sacks
    def initialize(name, att, comp, yards, teamAbbr, tds, sacks)
        @name = name
        @att = att.to_i
        @comp = comp.to_i
        @yards = yards.to_i
        @teamAbbr = teamAbbr
        @tds = tds
        @sacks = sacks
    end

    def to_s()
        @name + " (" + @teamAbbr + ")\n" +
        "   " + @yards.to_s + " yards\n" +
        "   " + @tds + " TDs\n" +
        "   " + @sacks + " sacks"
    end

    def self.pull()
        response = Unirest.get "http://api.fantasy.nfl.com/players/stats",
                       headers:{ "Accept" => "application/json" },
                       parameters:{ :position => "QB", :statType => "seasonStats", :season => 2013, :format => "json" }
        quarterbacks = response.body["players"]
        quarterbacks.select! { |qb|
            qb["stats"].has_key?("5") and
            qb["stats"].has_key?("3") and
            qb["stats"].has_key?("2") and
            qb["stats"].has_key?("6") and
            qb["stats"].has_key?("8")
        }
        quarterbacks.map! { |qb|
            Quarterback.new(
                qb["name"],         # Name.
                qb["stats"]["2"],   # Att.
                qb["stats"]["3"],   # Comp.
                qb["stats"]["5"],   # Total yards.
                qb["teamAbbr"],     # Team name abbreviation.
                qb["stats"]["6"],   # TDs.
                qb["stats"]["8"])   # Sacks.
        }
        quarterbacks.select! { |qb| qb.yards > 1000 }
        quarterbacks.sort! { |a, b| a.name <=> b.name }
    end
end