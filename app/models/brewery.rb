class Brewery < ActiveRecord::Base
  include RatingAverage
  #include Top

  validates :name, presence: true
  validates :year, numericality: { only_integer: true,
                                   greater_than: 1041 }
  validate :year_cannot_be_greater_than_current

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[false, nil] }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by { |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order.first(n)
  end

  def year_cannot_be_greater_than_current
    if :year.present? && year > Date.today.year
      errors.add(:year, "can't be in the future")
    end
  end

  def to_s
    "#{name}"
  end

end
