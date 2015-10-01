require 'spec_helper'

feature 'follow a user' do

  given(:me) { Fabricate(:user, full_name: 'Max Mustermann') }
  given(:mickey) { Fabricate(:user, full_name: 'Mickey Mouse') }
  given(:blockbusters) { Fabricate(:category, name: 'Blockbusters') }
  given(:sucker_punch) { Fabricate(:video, title: 'Sucker Punch', category: blockbusters )}

  background 'logged-in user' do
    Fabricate(:review, user: mickey, video: sucker_punch)
    sign_in me
  end

  scenario 'click on "Follow" adds the user to the list of the followers' do
    follow_reviewer_of_the_video sucker_punch, mickey
    click_link 'People'
    mickey_as_follower_link_selector = "//table/*/*/*/a[@href='#{user_path(mickey)}']"
    expect(page).to have_selector(mickey_as_follower_link_selector)
  end

  scenario 'followed user cannot be followed' do
    follow_reviewer_of_the_video sucker_punch, mickey
    click_link 'People'
    mickey_as_follower_link_selector = "//table/*/*/*/a[@href='#{user_path(mickey)}']"
    find(:xpath, mickey_as_follower_link_selector).click
    expect(page).not_to have_selector('Follow')
  end

end