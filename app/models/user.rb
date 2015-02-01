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
end
