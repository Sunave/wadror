class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  scope :pending, -> { where confirmed:[false, nil] }

  validates :user_id, uniqueness: { scope: :beer_club_id }
end
