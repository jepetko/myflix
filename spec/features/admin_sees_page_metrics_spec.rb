require 'spec_helper'

feature 'admin sees page metrics' do

  scenario 'regular user cannot access the page metrics' do
    user = Fabricate(:user)
    sign_in user
    visit admin_page_metrics_path
    expect(page).to have_content 'You need to be an admin to do that'
  end

  scenario 'admin can access the page metrics' do
    admin = Fabricate(:admin)
    sign_in admin
    visit admin_page_metrics_path
    expect(page).not_to have_content 'You need to be an admin to do that'
  end

end