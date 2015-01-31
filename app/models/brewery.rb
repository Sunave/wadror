class Brewery < ActiveRecord::Base
  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { only_integer: true,
                                   greater_than: 1041 }
  validate :year_cannot_be_greater_than_current

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def year_cannot_be_greater_than_current
    if :year.present? && year > Date.today.year
      errors.add(:year, "can't be in the future")
    end
  end

end
