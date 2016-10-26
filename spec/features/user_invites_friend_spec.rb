require 'spec_helper'

feature "User invites friend" do 
  scenario "User successfully invites friend and invitation is accepted", js: true, vcr: true do 
    alice = Fabricate(:user)
    sign_in(alice)
    sleep 2

    visit new_invitation_path
    fill_in "Friend's Name", with: "John Doe"
    fill_in "Friend's Email", with: "John@doe.com"
    fill_in "Message", with: "hello please join"
    click_button "Send Invitation"
    sleep 2

    sign_out 

    open_email "John@doe.com"
    current_email.click_link "Accept this invitation"
    sleep 2

    fill_in "Password", with: "password"
    fill_in "Full Name", with: "John Doe"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "10 - October", from: "date_month"
    select "2019", from: "date_year"
    click_button "Sign Up"
    sleep 2

    fill_in "Email Address", with: "John@doe.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
    sleep 2

    click_link "People"
    expect(page).to have_content alice.username
    sign_out
    sleep 1

    sign_in(alice)
    click_link "People"
    expect(page).to have_content "John Doe"
  end 
end

ActionMailer::Base.deliveries.clear

