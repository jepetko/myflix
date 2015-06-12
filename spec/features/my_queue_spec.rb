require 'spec_helper'

feature 'Video queue' do

  given(:user) { Fabricate(:user) }
  given!(:category) { Fabricate(:category, name: 'Blockbusters')}
  given!(:alien) { Fabricate(:video, title: 'Alien', category: category) }
  given!(:taxi_driver) { Fabricate(:video, title: 'Taxi driver', category: category) }

  background 'logged-in user' do
    visit sign_in_path
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button 'Sign in'
  end

  scenario 'adding videos to the queue' do
    visit videos_path

    find(:xpath, "//a[@href='#{video_path(alien)}']").click
    click_link '+ My Queue'
    queue_item = find(:xpath, "//td/a[@href='#{video_path(alien)}']")
    expect(queue_item.text()).to eq(alien.title)
    queue_item.click
    #expect(page).to_not have_content('+ My Queue')

    visit videos_path
    find(:xpath, "//a[@href='#{video_path(taxi_driver)}']").click
    click_link '+ My Queue'
    queue_item = find(:xpath, "//td/a[@href='#{video_path(taxi_driver)}']")
    expect(queue_item.text()).to eq(taxi_driver.title)
    #Note: this includes the table header
    expect(page).to have_selector('//form[@action="/update_queue"]//table//tr', count: 3)
  end

end