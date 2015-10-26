require 'spec_helper'

feature 'user registration', :vcr, :js do

  background { visit register_path }

  scenario 'both, user data valid and credit card data valid' do
    fill_in_user_details
    fill_in_credit_card_data '4242424242424242'
    click_button 'Sign up'
    expect(page).to have_xpath('//h1[text()="Sign in"]')
  end

  scenario 'user data valid and credit card data invalid' do
    fill_in_user_details
    fill_in_credit_card_data '4000000000000002'
    click_button 'Sign up'
    expect(page).to have_content('Your card was declined')
  end

  scenario 'user data invalid and credit card data valid' do
    fill_in_user_details true
    fill_in_credit_card_data '4242424242424242'
    click_button 'Sign up'
    expect(page).to have_xpath('//div[contains(@class, "has-error")]/div/input[@id="user_password_confirmation"]')
    expect(page).to have_content("doesn't match Password")
  end
end

def fill_in_user_details(simulate_wrong_password = false)
  fill_in 'Email', with: 'user@mailinator.com'
  password = '123'
  fill_in 'Password', with: password
  fill_in 'Password confirmation', with: simulate_wrong_password ? "#{password}x" : password
  fill_in 'Full name', with: 'Max Mustermann'
end

def fill_in_credit_card_data(credit_card_number)
  fill_in 'Credit Card Number', with: credit_card_number
  fill_in 'Security Code', with: '123'
  select '1 - January', from: 'date_month'
  select 1.year.from_now.year, from: 'date_year'
end