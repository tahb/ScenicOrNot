require "./app/services/leaderboard_calculator"

desc "calculate leaderboard"
task calculate_leaderboard: :environment do
  require "fileutils"
  FileUtils.mkdir_p "tmp"

  leaderboard_data = LeaderboardCalculator.new.as_json
  File.write("tmp/leaderboard.json", JSON.generate(leaderboard_data))
end
