require 'spec_helper'

feature 'User page' do

  given!(:user) { Fabricate(:user, full_name: 'Mickey Mouse') }
  given!(:category) { Fabricate(:category, name: 'David Lynch Movies')}
  given!(:video_1) { Fabricate(:video, title: 'Mulholland drive', category: category)}
  given!(:video_2) { Fabricate(:video, title: 'Lost Highway', category: category)}
  given!(:queue_item_1) { Fabricate(:queue_item, user: user, video: video_1)}
  given!(:queue_item_2) { Fabricate(:queue_item, user: user, video: video_2)}
  given!(:review) { Fabricate(:review, user: user, video: video_2, rating: 5) }

  background 'user page loaded' do
    visit sign_in_path
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign in'
    visit user_path(user)
  end

  scenario 'user page contains the video queue list, review list and the follow button' do
    expect(page).to have_content("#{user.full_name}'s video collection (2)")

    queue_item_link_1 = find(:xpath, "//td/a[@href='#{video_path(video_1)}']")
    expect(queue_item_link_1.text()).to eq(video_1.title)
    queue_item_link_2 = find(:xpath, "//td/a[@href='#{video_path(video_2)}']")
    expect(queue_item_link_2.text()).to eq(video_2.title)

    expect(page).to have_content("#{user.full_name}'s reviews (1)")

    col_selector = "//*[@class='row']/*[@class='col-sm-2']"
    review_item_video_link_1 = find(:xpath, "#{col_selector}/p[1]/a[@href='#{video_path(video_2)}']")
    expect(review_item_video_link_1.text()).to eq("\"#{video_2.title}\"")
    review_item_video_link_1_rating = find(:xpath, "#{col_selector}/p[2]")
    expect(review_item_video_link_1_rating.text()).to eq('Rating: 5 / 5')

    # because the user is the current logged-in user who cannot follow himself
    expect(page).not_to have_content('Follow')
  end
end