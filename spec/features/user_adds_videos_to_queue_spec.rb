require 'spec_helper'

feature "user interacts with the queue" do 
  scenario "user adds and reorders videos in the queue" do 
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)
    futurama = Fabricate(:video, title: "Futurama", category: comedies)
    
    sign_in

    [monk, south_park, futurama].each do |video|
      add_to_queue(video)
      expect_video_to_be_in_queue(video)
      visit video_path(video)
      expect_queue_link_to_be_hidden
    end

    visit my_queue_path
    set_video_position(monk, 3)
    set_video_position(south_park, 1)
    set_video_position(futurama, 2)

    click_button "Update Instant Queue"

    expect_video_position(south_park, 1)
    expect_video_position(futurama, 2)
    expect_video_position(monk, 3)
  end
end

def set_video_position(video, new_pos)
  fill_in "video_#{video.id}", with: new_pos
end

def expect_video_position(video, pos)
  expect(find("#video_#{video.id}").value).to eq("#{pos}")
end

def add_to_queue(video)
  visit home_path
  view(video)
  click_link "+ My Queue"
end

def expect_video_to_be_in_queue(video)
  page.should have_content(video.title)
end

def expect_queue_link_to_be_hidden
  page.should_not have_content "+ My Queue"
end