class Quarterback
    attr_accessor :name, :att, :comp, :yards, :teamAbbr
    def initialize(name, att, comp, yards, teamAbbr)
        @name = name
        @att = att.to_i
        @comp = comp.to_i
        @yards = yards.to_i
        @teamAbbr = teamAbbr
    end

    def to_s()
        @name + " (" + @teamAbbr + ", " + @yards.to_s + " yd)"
    end
end