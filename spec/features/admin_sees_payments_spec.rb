require 'spec_helper'

feature 'admin sees payments' do

  scenario 'regular user cannot see payments' do
    user = Fabricate(:user)
    sign_in user
    visit admin_payments_path
    expect(page).to have_content('You need to be an admin to do that')
  end

  scenario 'admin can see payments of the regular users' do
    admin = Fabricate(:admin, email: 'admin@domain.com', full_name: 'John Doe')
    payment = Fabricate(:payment, amount: '888', reference_id: 'ch_123')
    sign_in admin
    visit admin_payments_path
    expect(page).to have_xpath("//td[text()='#{payment.user.email}']")
    expect(page).to have_xpath("//td[text()='#{payment.user.full_name}']")
    expect(page).to have_xpath("//td[text()='8.88 €']")
    expect(page).to have_xpath("//td[text()='ch_123']")
  end

end