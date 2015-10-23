require 'spec_helper'

feature 'invitation' do

  given(:tom) { Fabricate(:user, full_name: 'Tom, the cat') }
  given(:jerrys_email) { 'jerry@mice.com' }
  given(:jerrys_name) { 'Jerry, the mouse' }

  background 'tom is signed-in and invites jerry' do

    clear_emails
    sign_in tom

    visit invite_path
    fill_in :invitation_email, with: jerrys_email
    fill_in :invitation_full_name, with: jerrys_name
    click_button 'Send Invitation'
    open_email jerrys_email
  end

  scenario 'jerry receives an email' do
    expect(current_email.to).to include jerrys_email
    expect(current_email.body).to have_content jerrys_name
  end

  scenario 'jerry can confirm the invitation' do
    href = confirm_invitation_path(Invitation.last.token)
    expect(current_email.body).to have_xpath "//a[contains(@href,'#{href}')]"
  end

  scenario 'jerry is able to register' do
    current_email.click_link 'link'
    expect(page).to have_content 'Register'
    expect(page).to have_xpath "//input[@value='#{jerrys_email}']"
    expect(page).to have_xpath "//input[@value='#{jerrys_name}']"
  end

  scenario 'jerry is the follower of tom after the registration', {vcr: true, js: true} do
    # sign out the current user Tom ...
    sign_out tom

    current_email.click_link 'link'
    fill_in 'Password', with: 'start123'
    fill_in 'Password confirmation', with: 'start123'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '123'
    select '12 - December', from: 'date_month'
    select '2018', from: 'date_year'
    click_button 'Sign up'

    # sign in the invited user Jerry
    jerry = User.last
    jerry.password = 'start123'
    sign_in jerry

    click_link 'People'
    # people I follow page displays Tom, the cat
    expect(page).to have_content tom.full_name
  end

end