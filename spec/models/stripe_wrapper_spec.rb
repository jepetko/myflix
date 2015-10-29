require 'spec_helper'

describe StripeWrapper, :vcr do
  let(:token) {
    future = 12.month.from_now
    Stripe::Token.create(
        card: {
            number: card_number,
            exp_month: future.month,
            exp_year: future.year,
            cvc: '123'
        }
    ).id
  }

  describe 'StripeWrapper::Charge#create' do

    context 'for valid cards' do

      let(:card_number) { '4242424242424242' }
      it 'is successful' do
        response = StripeWrapper::Charge.create(card: token, description: 'Myflix sign up charge')
        expect(response).to be_successful
      end

    end

    context 'for invalid card number' do

      let(:card_number) { '4000000000000002' }
      it 'declines payment' do
        response = StripeWrapper::Charge.create(card: token, description: 'Myflix sign up charge')
        expect(response).not_to be_successful
        expect(response.error_type).to eq 'Stripe::CardError'
        expect(response.error_message).to eq 'Your card was declined.'
      end

    end
  end

  describe 'StripeWrapper::Customer#subscribe' do

    let(:plan) {
      Stripe::Plan.create(
          :amount => 999,
          :interval => 'month',
          :name => 'myflix standard plan',
          :currency => 'usd',
          :id => 'standard'
      )
    }
    let(:user) { Fabricate(:user) }

    context 'valid credit card' do

      let(:card_number) { '4242424242424242' }
      before do
        response = StripeWrapper::Customer.subscribe(source: token, user: user)
      end

      it 'subscribes a user for recurring payments' do
        expect(response).to be_successful
      end

      it 'associates the customer id with the user' do
        expect(user.stripe_id).to eq(response.customer_id)
      end
    end

    context 'invalid credit card' do

      let(:card_number) { '4000000000000002' }
      before do
        response = StripeWrapper::Customer.subscribe(source: token, user: user)
      end

      it 'declines the subscription' do
        expect(response).not_to be_successful
        expect(response.error_type).to eq 'Stripe::CardError'
        expect(response.error_message).to eq 'Your card was declined.'
      end
    end
  end
end