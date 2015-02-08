class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
            length: { in: 3..15 }
  validates :password,
            length: { minimum: 4 },
            format: { with: /([A-Z].*[0-9]|[0-9].*[A-Z])/,
                      message: "should have at least one number and one capital letter" }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    Hash[users_beer_styles.map { |s| [s, average_rating_for_style(s)]}].max_by{ |k, v| v }[0]
  end

  def users_beer_styles
    beers.map { |b| b.style }.to_set
  end

  def average_rating_for_style(style_to_find)
    ratings_of_style  = ratings.find_all { |r| r.beer.style == style_to_find }.map{ |r| r.score }
    ratings_of_style.sum / ratings_of_style.count.to_f
  end

  def favorite_brewery
    return nil if ratings.empty?
    favorite_brewery_id = Hash[users_rated_breweries.map { |b|
                      [b, average_rating_for_brewery(b)]}].max_by{ |k, v| v }[0]
    Brewery.find_by(id:favorite_brewery_id).name
  end

  def users_rated_breweries
    beers.map { |b| b.brewery_id }.to_set
  end

  def average_rating_for_brewery(brewery_id_to_find)
    ratings_of_brewery = ratings.find_all { |r|
      r.beer.brewery_id == brewery_id_to_find }.map{ |r| r.score }
    ratings_of_brewery.sum / ratings_of_brewery.count.to_f
  end

end
