class UpdateRatingWorker
  include Sidekiq::Worker

  def perform
    while true do
      Rails.cache.write("recent ratings", Rating.recent)
      Rails.cache.write("breweries top 3", Brewery.top(3))
      Rails.cache.write("beers top 3", Beer.top(3))
      Rails.cache.write("raters top 3", User.includes(:beers, :ratings).top_raters(3))
      Rails.cache.write("styles top 3", Style.top(3))
      sleep 10.minutes
    end
  end
end