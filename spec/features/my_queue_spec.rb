require 'spec_helper'

feature 'Video queue' do

  given(:user) { Fabricate(:user) }
  given!(:category) { Fabricate(:category, name: 'Blockbusters') }
  given!(:alien) { Fabricate(:video, title: 'Alien', category: category) }
  given!(:taxi_driver) { Fabricate(:video, title: 'Taxi driver', category: category) }

  background 'logged-in user' do
    sign_in
  end

  feature 'adding video to the queue' do
    background 'going to the video item page and clicking "+ Queue Item"' do
      visit videos_path
      find(:xpath, "//a[@href='#{video_path(alien)}']").click
      click_link '+ My Queue'
    end

    scenario 'it displays the video in the queue item table' do
      queue_item_link = find(:xpath, "//td/a[@href='#{video_path(alien)}']")
      expect(queue_item_link.text()).to eq(alien.title)
      #By now, the table has 3 rows incl. the header
      expect(page).to have_selector('//form[@action="/update_queue"]//table//tr', count: 2)
    end

    scenario 'it disables the "+ Queue Item" button' do
      queue_item_link = find(:xpath, "//td/a[@href='#{video_path(alien)}']")
      queue_item_link.click
      expect(page).to_not have_content('+ My Queue')
    end
  end

  feature 'reordering the priority of the queue items' do
    background 'adding videos "Alien" and "Taxi Driver" to the queue' do
      visit video_path(alien)
      click_link '+ My Queue'
      visit video_path(taxi_driver)
      click_link '+ My Queue'
    end

    scenario 'it display two inputs for reordering the queue items' do
      expect(page).to have_selector("//input[@id='queue_items[][order_value]']", count: 2)
    end

    scenario 'it decreases the priority of "Alien" so that "Taxi Driver" appears first' do
      first(:xpath, "//input[@id='queue_items[][order_value]']").set '3'
      click_button 'Update Instant Queue'
      expect(first(:xpath, '//td/a').text()).to eq taxi_driver.title
    end
  end

end