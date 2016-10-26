require 'spec_helper'

feature 'Admin adds new video' do 
  scenario 'Admin successfully adds video' do 
    category = Fabricate(:category)

    sign_in(nil, admin: true)
    visit new_admin_video_path

    fill_in 'Title', with: 'Test'
    select(category.tag, from: 'Category')
    fill_in 'Description', with: "Description test."
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.example.com/my_vid.mp4"
    click_button "Add Video"
    sleep 1

    sign_out
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/my_vid.mp4']")

  end
end