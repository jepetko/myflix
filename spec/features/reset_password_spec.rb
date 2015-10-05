require 'spec_helper'

feature 'reset password workflow' do

  given(:user) { Fabricate(:user) }

  background 'user requests the password reset' do
    clear_emails
    visit sign_in_path
    click_link 'Forgot password?'
    fill_in :email, with: user.email
    click_button 'Send Email'
    open_email user.email
  end

  scenario 'mail is sent to the right user' do
    expect(current_email.to).to include user.email
    expect(current_email).to have_content user.full_name
  end

  scenario 'mail contains a reset password link' do
    expect(current_email).to have_link 'link'
  end

  scenario 'user is redirected to the reset password page' do
    current_email.click_link 'link'
    expect(page).to have_content 'Reset Your Password'
    expect(page).to have_field(:password)
  end

  scenario 'user sets the new password' do
    current_email.click_link 'link'
    fill_in :password, with: 'newPwd123'
    click_button 'Reset Password'
    expect(page).to have_content('Sign in')
  end

  scenario 'user can log in' do
    current_email.click_link 'link'
    fill_in :password, with: 'newPwd123'
    click_button 'Reset Password'
    fill_in :email, with: user.email
    fill_in :password, with: 'newPwd123'
    click_button 'Sign in'
    expect(page).to have_content "Welcome, #{user.full_name}"
  end
end