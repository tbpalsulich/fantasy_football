# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'unirest'
require_relative 'quarterback'

response = Unirest.get "http://api.fantasy.nfl.com/players/stats",
                       headers:{ "Accept" => "application/json" }, 
                       parameters:{ :statType => "seasonStats", :season => 2013, :format => "json" }

players = Hash.new { |hash, key| hash[key] = [] }
response.body["players"].each do |player|
    players[player["position"]] << player
end
players["QB"].select! { |qb| qb["stats"].has_key?("5") and qb["stats"].has_key?("3") and qb["stats"].has_key?("2")}
players["QB"].map! { |qb| Quarterback.new(qb["name"], qb["stats"]["2"], qb["stats"]["3"], qb["stats"]["5"], qb["name"])}
players["QB"].select! { |qb| qb.yards > 1000 }
players["QB"].sort! { |a, b| a.name <=> b.name }

puts "Quarterbacks:"
puts players["QB"].map { |qb| qb.to_s }.join("\n")