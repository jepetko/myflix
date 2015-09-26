require 'spec_helper'

feature 'unfollow a user' do

  given(:me) { Fabricate(:user, full_name: 'Max Mustermann') }
  given(:mickey) { Fabricate(:user, full_name: 'Mickey Mouse') }
  given(:blockbusters) { Fabricate(:category, name: 'Blockbusters') }
  given!(:sucker_punch) { Fabricate(:video, title: 'Sucker Punch', category: blockbusters )}

  background 'logged-in user' do
    Fabricate(:review, user: mickey, video: sucker_punch)
    sign_in me
  end

  scenario 'click on (X) removes the user from the follower list' do
    follow_reviewer_of_the_video sucker_punch, mickey
    click_link 'People'
    find(:path, '//table/*/*/td[last()]/a').click
    click_link 'People'
    expect(page).not_to have_content(mickey.full_name)
  end

end