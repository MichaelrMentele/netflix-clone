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

    click_link(bob.username)
    page.should have_content bob.username

    click_link("Follow")
    page.should have_content "People I Follow"
    page.should have_content bob.username

    find_link(href: "/relationships/#{Relationship.first.id}" ).click
    page.should_not have_content bob.username
  end
end