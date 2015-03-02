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
  has_many :memberships, -> { where confirmed: true }, dependent: :destroy
  has_many :pending_memberships, -> { pending }, class_name: 'Membership', dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["extra"]["raw_info"]["login"]
      user.password = (('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a).shuffle.first(20).join

    end
  end

  def self.top_raters(n)
    User.all.sort_by{ |u| -(u.ratings.count||0) }.first(n)
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite_style
    favorite :style
  end

  # def method_missing(method_name, *args, &block)
  #   if method_name =~ /^favorite_/
  #     category = method_name[9..-1].to_sym
  #     self.favorite category
  #   else
  #     return super
  #   end
  # end

  def favorite(category)
    return nil if ratings.empty?
    category_ratings = rated(category).inject([]) do |set, item|
      set << { item: item, rating: rating_of(category, item) }
    end
    category_ratings.sort_by { |item| item[:rating] }.last[:item]
  end

  def rated(category)
    ratings.map{ |r| r.beer.send(category) }.uniq
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end

end
