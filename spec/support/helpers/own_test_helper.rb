# Doing nothing at the moment, method moved to rails_helper.rb. If you manage to get this working,
# please remove this comment.

module OwnTestHelper

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end
end