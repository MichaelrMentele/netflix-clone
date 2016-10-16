# click on people link
# verify the user is in the list
# unfollow that person
# veify person is no longer in this list
require 'spec_helper'

feature "social" do
  scenario "user follows and unfollows other user" do
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    alice = Fabricate(:user)
    bob = Fabricate(:user)
    review = Fabricate(:review, video: monk, user: bob)

    sign_in(alice)
    page.should have_content alice.username

    visit home_path
    view(monk)

    navigate_to_reviewer_profile(bob)
    page.should have_content bob.username

    follow(bob)
    page.should have_content "People I Follow"
    page.should have_content bob.username

    unfollow(bob)
    page.should_not have_content bob.username
  end
end

def navigate_to_reviewer_profile(user)
  click_link(user.username)
end

def follow(user)
  click_link("Follow")
end

def unfollow(user)
  find_link(href: "/relationships/#{Relationship.first.id}" ).click
end