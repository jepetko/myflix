require 'spec_helper'

describe StripeWrapper::Charge do

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

  context 'for valid cards' do

    let(:card_number) { '4242424242424242' }
    it 'is successful' do
      response = StripeWrapper::Charge.create(card: token, description: 'Myflix sign up charge')
      expect(response).to be_successful
    end

  end

  context 'like invalid card number' do

    let(:card_number) { '4000000000000002' }
    it 'declines payment' do
      response = StripeWrapper::Charge.create(card: token, description: 'Myflix sign up charge')
      expect(response).not_to be_successful
      expect(response.error_type).to eq 'Stripe::CardError'
      expect(response.error_message).to eq 'Your card was declined.'
    end

  end

end