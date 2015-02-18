require 'rails_helper'

describe Style do
  it "has one after created" do
    Style.create name:"Lager", description: "Nice"
    expect(Style.count).to eq(1)
  end
end
