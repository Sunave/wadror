require 'rails_helper'

describe Beer do
  it "is saved when name and style has been set" do
    beer = Beer.create name:"Punk IPA", style:"IPA"

    expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end

  it "is not saved without name" do
    beer = Beer.create style:"IPA"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    beer = Beer.create name:"Punk IPA"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

end
