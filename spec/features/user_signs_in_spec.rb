require 'spec_helper'

feature 'User signs in' do 
  background do 
  end
  
  scenario "with existing username" do 
    visit root_path
  end
end