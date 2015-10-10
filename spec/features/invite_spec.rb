require 'spec_helper'

feature 'invitation' do

  given(:tom) { Fabricate(:user, full_name: 'Tom, the cat') }
  given(:jerrys_email) { 'jerry@mice.com' }
  given(:jerrys_name) { 'Jerry, the mouse' }

  background 'tom is signed-in and invites jerry' do

    clear_emails
    sign_in tom

    visit invite_path
    p page.body
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
    # workaround: replace the host:port
    href = confirm_invitation_url(Invitation.last.token, host: 'localhost:3000')
    expect(current_email.body).to have_xpath "//a[@href='#{href}']"
  end

  scenario 'jerry is able to register' do
    current_email.click_link 'link'
    expect(page).to have_content 'Register'
    expect(page).to have_xpath "//input[@value='#{jerrys_email}']"
    expect(page).to have_xpath "//input[@value='#{jerrys_name}']"
  end

  scenario 'jerry is the follower of tom after the registration' do
    # sign out the current user Tom ...
    sign_out

    current_email.click_link 'link'
    fill_in :user_password, with: 'start123'
    fill_in :user_password_confirmation, with: 'start123'
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