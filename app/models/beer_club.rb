class BeerClub < ActiveRecord::Base
  has_many :members, -> { uniq }, through: :memberships, source: :user
  has_many :memberships, -> { where confirmed: true }, dependent: :destroy
  #has_many :pending_members, class_name: 'User', through: :pending_memberships, source: :user
  has_many :pending_memberships, -> { pending }, class_name: 'Membership', dependent: :destroy
end
