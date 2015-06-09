require 'spec_helper'

feature 'Login' do

  given(:user) { Fabricate(:user, full_name: 'Mickey Mouse') }

  background 'email filled in' do
    visit sign_in_path
    fill_in :email, with: user.email
  end

  scenario 'Login successful' do
    fill_in :password, with: user.password
    click_button 'Sign in'
    expect(page).to have_content("Welcome, #{user.full_name}")
  end

  scenario 'Login failed' do
    fill_in :password, with: 'wrong password'
    click_button 'Sign in'
    expect(page).to have_content('Your login credentials are invalid.')
  end
end