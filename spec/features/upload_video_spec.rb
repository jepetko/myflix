require 'spec_helper'

feature 'Video upload' do

  given(:user) { Fabricate(:user) }
  given(:admin) { Fabricate(:admin) }

  background 'existing category Trainings' do
    Fabricate(:category, name: 'Trainings')
  end

  scenario 'admin can upload a video which can be watched by a regular user', js: true do
    sign_in admin
    visit new_admin_video_path
    fill_in :video_title, with: 'Dog training'
    fill_in :video_description, with: 'This video shows you how to train dogs'
    select 'Trainings', from: :video_category_id
    attach_file :video_large_cover, File.join(Rails.root, 'spec', 'fabricators', 'assets', 'picture_dummy.png')
    attach_file :video_small_cover, File.join(Rails.root, 'spec', 'fabricators', 'assets', 'picture_dummy.png')
    fill_in :video_remote_link_url, with: Fabricate.attributes_for(:video)[:link]
    click_button 'Add video'
    expect(page).to have_content('The video Dog training has been created')
    sign_out admin

    sign_in user
    video = Video.last
    visit videos_path
    find(:xpath, "//a[@href='#{video_path(video)}']").click
    expect(page).to have_xpath("//video[@poster='#{video.large_cover.url}']")
    expect(page).to have_xpath("//video/source[@src='#{video.link.url}']")
    click_button 'Watch now'
    #capybara-webkit issue on CircleCI; poltergeist does not recognize video.play().... maybe QT4 => 5 upgrade necessary?
    #expect(page).to have_button('Pause')
  end
end