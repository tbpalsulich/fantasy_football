require 'unirest'

class Quarterback
    attr_accessor :name, :att, :comp, :yards, :teamAbbr, :tds, :sacks, :compPct, :rushAvg
    def initialize(name, att, comp, yards, teamAbbr, tds, sacks, rushAtt, rushYds)
        @name = name
        @att = att.to_i
        @comp = comp.to_i
        @compPct = @comp.to_f / @att
        @yards = yards.to_i
        @teamAbbr = teamAbbr
        @tds = tds.to_i
        @sacks = sacks.to_i
        @rushAtt = rushAtt.to_i
        @rushYds = rushYds.to_i
        @rushAvg = @rushYds.to_f / @rushAtt
    end

    def to_s()
        @name + " (" + @teamAbbr + ")\n" +
        "   " + @yards.to_s + " yards\n" +
        "   " + @tds.to_s + " TDs\n" +
        "   " + @sacks.to_s + " sacks\n" +
        "   " + @comp.to_s + "/" + @att.to_s + " comp (" + @compPct.round(2).to_s + ")\n" +
        "   " + @rushAtt.to_s + " rush/" + @rushYds.to_s + " yards (" + @rushAvg.round(2).to_s + ")"
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
            qb["stats"].has_key?("8") and
            qb["stats"].has_key?("13") and
            qb["stats"].has_key?("14")
        }
        quarterbacks.map! { |qb|
            Quarterback.new(
                qb["name"],         # Name.
                qb["stats"]["2"],   # Att.
                qb["stats"]["3"],   # Comp.
                qb["stats"]["5"],   # Total yards.
                qb["teamAbbr"],     # Team name abbreviation.
                qb["stats"]["6"],   # TDs.
                qb["stats"]["8"],   # Sacks.
                qb["stats"]["13"],  # Rushes.
                qb["stats"]["14"])  # Rush yards.
        }
        # quarterbacks.select! { |qb| qb.yards > 1000 }
        quarterbacks.sort! { |a, b| b.compPct <=> a.compPct }
    end
end