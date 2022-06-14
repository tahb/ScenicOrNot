require "./app/services/leaderboard"

desc "calculate leaderboard"
task calculate_leaderboard: :environment do
  leaderboard_data = Leaderboard.new.as_json

  require "fileutils"
  FileUtils.mkdir_p "tmp"

  File.write("tmp/leaderboard.json", JSON.generate(leaderboard_data))


end
