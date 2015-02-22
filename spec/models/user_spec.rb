require 'rails_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = User.create username:"Pekka", password:"Sc1", password_confirmation:"Sc1"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved when password has only letters" do
    user = User.create username:"Pekka", password:"Salasana", password_confirmation:"Salasana"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating(10, user)
      best = create_beer_with_rating(25, user)
      create_beer_with_rating(7, user)

      expect(user.favorite_beer).to eq(best)
    end
  end
end

describe "favorite style" do
  let(:user){ FactoryGirl.create(:user) }

  it "has method for determinig one" do
    expect(user).to respond_to(:favorite_style)
  end

  it "without ratings doesn't have one" do
    expect(user.favorite_style).to eq(nil)
  end

  it "returns the right average even when highest has less ratings" do
    beer = FactoryGirl.create(:beer)
    beer2 = FactoryGirl.create(:beer2)
    user.ratings << FactoryGirl.create(:rating, score:17, beer:beer, user:user)
    user.ratings << FactoryGirl.create(:rating, score:23, beer:beer, user:user)
    user.ratings << FactoryGirl.create(:rating2, score:43, beer:beer2, user:user)

    expect(user.favorite_style).to eq(beer2.style)
  end
end

describe "favorite brewery" do
  let(:user){ FactoryGirl.create(:user) }

  it "has method for determining one" do
    expect(user).to respond_to(:favorite_brewery)
  end

  it "without ratings doesn't have one" do
    expect(user.favorite_style).to eq(nil)
  end

  it "returns the brewery when there's only one rating" do
    brewery = FactoryGirl.create(:brewery, name:"Koff")
    beer = create_beer_with_rating(10, user, brewery)

    expect(user.favorite_brewery).to eq(brewery)
  end

  it "returns the right one even when highest has less ratings" do
    FactoryGirl.create(:brewery)
    brw2 = FactoryGirl.create(:brewery, name:"favoritous")
    beer = FactoryGirl.create(:beer)
    beer2 = FactoryGirl.create(:beer2, brewery: brw2)
    user.ratings << FactoryGirl.create(:rating, score:17, beer:beer, user:user)
    user.ratings << FactoryGirl.create(:rating, score:23, beer:beer, user:user)
    user.ratings << FactoryGirl.create(:rating2, score:43, beer:beer2, user:user)

   expect(user.favorite_brewery).to eq(brw2)
  end
end

def create_beer_with_rating(score, user, brewery=nil, style=nil)
  brewery ||= FactoryGirl.create(:brewery)
  if style.nil?
    style = FactoryGirl.create(:style)
  elsif style.is_a? String
    style = FactoryGirl.create(:style, name: style)
  end

  beer = FactoryGirl.create(:beer, brewery: brewery, style: style)
  FactoryGirl.create(:rating, score: score, beer: beer, user: user)
  beer
end

def create_beers_with_ratings(*score, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end


