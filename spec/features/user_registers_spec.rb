require 'spec_helper'

feature 'user registers', { js: true, vcr: true } do
  background do 
    visit register_path
  end 

  scenario 'with valid personal info and valid credit info' do 
    fill_in_valid_user
    fill_in_valid_card
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content "Thank you for registering with MyFlix. Please sign in now."
  end

  scenario 'with valid personal info but invalid credit info' do 
    fill_in_valid_user
    fill_in_invalid_card
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content "The card number is not a valid credit card number."
  end

  scenario 'and has valid user info but declined card' do
    fill_in_valid_user
    fill_in_declined_card
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content "Your card was declined."
  end

  scenario 'with invalid personal info and valid card' do
    fill_in_invalid_user
    fill_in_valid_card
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content "Invalid user information. Please check the errors below."
  end

  scenario 'with invalid user and invalid card' do 
    fill_in_invalid_user
    fill_in_invalid_card    
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content "The card number is not a valid credit card number."
  end

  scenario 'and has invalid user info and declined card' do 
    fill_in_invalid_user
    fill_in_declined_card
    click_button "Sign Up"
    sleep 1
    expect(page).to have_content "Invalid user information. Please check the errors below."
  end
end

def fill_in_valid_user
  fill_in "Email Address", with: "Kevin@wang.com"
  fill_in "Password", with: "password"
  fill_in "Full Name", with: "John Doe"
end

def fill_in_valid_card
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "123"
  select "10 - October", from: "date_month"
  select "2019", from: "date_year"
end

def fill_in_invalid_user
  fill_in "Email Address", with: "Kevin@user"
  fill_in "Full Name", with: "John Doe"
end

def fill_in_invalid_card
  fill_in "Credit Card Number", with: "424"
  fill_in "Security Code", with: "123"
  select "10 - October", from: "date_month"
  select "2019", from: "date_year"
end

def fill_in_declined_card
  fill_in "Credit Card Number", with: "4000000000000002"
  fill_in "Security Code", with: "123"
  select "10 - October", from: "date_month"
  select "2019", from: "date_year"
end