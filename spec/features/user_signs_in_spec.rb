require 'spec_helper'

feature 'User signs in' do 
  scenario "with valid email and password" do 
    alice = Fabricate(:user)
    sign_in(alice)
    page.should have_content alice.username
  end

  scenario "with deactivated user" do 
    alice = Fabricate(:user, active: false)
    sign_in(alice)
    expect(page).not_to have_content alice.username
    expect(page).to have_content("Your account has been suspended, please contact customer service.")
  end
end
