require 'rails_helper'

describe 'Beers' do
  before :each do
    FactoryGirl.create :user
    FactoryGirl.create :style
    FactoryGirl.create :brewery
  end

  it "creates beer which has non-empty name" do
    sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
    fill_in('beer[name]', with:'Nonempty')
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "doesn't let you create beer without name" do
    sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
    fill_in('beer[name]', with: '')
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)
    expect(page).to have_content "Name can't be blank"
  end


end