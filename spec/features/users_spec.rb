require 'rails_helper'

describe "User" do
  before :each do
    @user = FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "sees only her own ratings" do
    create_test_variables
    sign_in(username:"Pekka", password:"Foobar1")
    visit user_path(@user)
    expect(page).to have_content "iso 3 17"
    expect(page).not_to have_content "iso 3 18"
  end

  it "destroys removed rating" do
    create_test_variables
    sign_in(username:"Pekka", password:"Foobar1")
    visit user_path(@user)
    all('.delete')[0].click
    expect(page).not_to have_content "iso 3 17"
    expect(@user.ratings.count).to eq(1)
  end

  it "shows favorite beer and favorite brewery" do
    create_test_variables
    sign_in(username:"Pekka", password:"Foobar1")
    visit user_path(@user)
    expect(page).to have_content "Favorites"
    expect(page).to have_content "Beer style: #{@user.favorite_style}"
    expect(page).to have_content "Brewery: #{@user.favorite_brewery}"
  end
end

def create_test_variables
  @user2 = User.create username:"Wrongwong", password:"Salis1", password_confirmation:"Salis1"
  @brewery = FactoryGirl.create :brewery, name:"Koff"
  @beer1 = FactoryGirl.create :beer, name:"iso 3", brewery:@brewery
  @rating1 = FactoryGirl.create :rating, score: 17, beer:@beer1, user:@user
  @rating2 = FactoryGirl.create :rating, score: 48, beer:@beer1, user:@user
  @rating3 = FactoryGirl.create :rating, score: 18, beer:@beer1, user:@user2
end