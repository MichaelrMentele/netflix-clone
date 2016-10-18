require 'spec_helper'

feature "User invites friend" do 
  scenario "User successfully invites friend and invitation is accepted" do 
    alice = Fabricate(:user)
    sign_in(alice)

    visit new_invitation_path
    fill_in "Friend's Name", with: "John Doe"
    fill_in "Friend's Email", with: "John@doe.com"
    fill_in "Message", with: "hello please join"
    click_button "Send Invitation"
    sign_out 

    open_email "John@doe.com"
    current_email.click_link "Accept this invitation"

    fill_in "Password", with: "password"
    fill_in "Full Name", with: "John Doe"
    click_button "Sign Up"

    fill_in "Email Address", with: "John@doe.com"
    fill_in "Password", with: "password"
    click_button "Sign in"

    click_link "People"
    expect(page).to have_content alice.username
    sign_out

    sign_in(alice)
    click_link "People"
    expect(page).to have_content "John Doe"
  end 
end

ActionMailer::Base.deliveries.clear

