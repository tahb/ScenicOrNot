desc "Remove the host name from image_uri"
task make_image_uri_relative: :environment do
  Place.all.each do |place|
    place.image_uri.gsub!(/.+\//, "")
    place.save!
  end
end
