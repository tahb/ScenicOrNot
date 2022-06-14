class LeaderboardPresenter
  include ActionView::Helpers::NumberHelper


  def initialize(leaderboard: nil)
    if File.exist?("tmp/leaderboard.json")
      leaderboard_data = File.read("tmp/leaderboard.json")
      @leaderboard = Leaderboard.new.from_json(leaderboard_data)
    else
      @leaderboard = Leaderboard.new
    end
  end

  def top_five
    @leaderboard.most_scenic_places.map { |result| PlaceWithRating.new(result) }
  end

  def bottom_five
    @leaderboard.least_scenic_places.map { |result| PlaceWithRating.new(result) }
  end

  def percentage_rated
    "#{number_with_precision(@leaderboard.percentage_rated, precision: 2, strip_insignificant_zeros: true)}%"
  end
end
