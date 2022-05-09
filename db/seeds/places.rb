require "csv"

places_filename = File.join(
  Rails.root,
  "db",
  "data",
  "places.csv"
)

inactive_images_filename = File.join(
  Rails.root,
  "db",
  "data",
  "missing_photos.csv"
)

inactive_images = CSV.parse(
  File.read(inactive_images_filename, encoding: "BOM|UTF-8"),
  headers: true
).map { |row| row[:gridimage_id] }

SmarterCSV.process(places_filename, chunk_size: 1000) do |chunk|
  rows = []

  chunk.each do |row|
    geograph_id = row[:geograph_uri].split("/").last
    image_code = row[:image_uri].split("/").last
    image_uri = [ENV["S3_HOSTNAME"], image_code].join("/")

    rows << {
      id: row[:id],
      geograph_id: geograph_id,
      title: row[:title],
      description: row[:description],
      subject: row[:subject],
      creator: row[:creator],
      creator_uri: row[:creator_uri],
      date_submitted: DateTime.parse(row[:date_submitted]),
      lat: row[:lat],
      lon: row[:lon],
      gridsquare: row[:gridsquare],
      license_uri: row[:license_uri],
      format: row[:format],
      vote_count: row[:votes],
      random: row[:random],
      width: row[:width],
      height: row[:height],
      aspect: row[:aspect],
      geograph_image_uri: row[:image_uri],
      image_uri: image_uri,
      active_on_geograph: !inactive_images.include?(geograph_id)
    }
  end

  Place.import rows
end
