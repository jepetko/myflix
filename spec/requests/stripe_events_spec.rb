require 'spec_helper'

describe 'Stripe Events' do

  describe 'charge.succeeded' do

    let(:customer_id) { 'cus_7Ft1EjfovZ9ipp' }
    let(:event_data) do
      {
          'created' => 1326853478,
          'livemode' => false,
          'id' => 'evt_171NFlFsBqZq4amV27Bkc7YO',
          'type' => 'charge.succeeded',
          'object' => 'event',
          'request' => nil,
          'pending_webhooks' => 1,
          'api_version' => '2015-10-16',
          'data' => {
              'object' => {
                  'id' => 'ch_171NFkFsBqZq4amV41bQYS9B',
                  'object' => 'charge',
                  'amount' => 999,
                  'amount_refunded' => 0,
                  'application_fee' => nil,
                  'balance_transaction' => 'txn_171NFkFsBqZq4amVebFcBAqX',
                  'captured' => true,
                  'created' => 1446151448,
                  'currency' => 'eur',
                  'customer' => customer_id,
                  'description' => nil,
                  'destination' => nil,
                  'dispute' => nil,
                  'failure_code' => nil,
                  'failure_message' => nil,
                  'fraud_details' => {
                  },
                  'invoice' => 'in_171NFkFsBqZq4amVLnVD6RHg',
                  'livemode' => false,
                  'metadata' => {
                  },
                  'paid' => true,
                  'receipt_email' => nil,
                  'receipt_number' => nil,
                  'refunded' => false,
                  'refunds' => {
                      'object' => 'list',
                      'data' => [

                      ],
                      'has_more' => false,
                      'total_count' => 0,
                      'url' => '/v1/charges/ch_171NFkFsBqZq4amV41bQYS9B/refunds'
                  },
                  'shipping' => nil,
                  'source' => {
                      'id' => 'card_171NFjFsBqZq4amVcPla2v1w',
                      'object' => 'card',
                      'address_city' => nil,
                      'address_country' => nil,
                      'address_line1' => nil,
                      'address_line1_check' => nil,
                      'address_line2' => nil,
                      'address_state' => nil,
                      'address_zip' => nil,
                      'address_zip_check' => nil,
                      'brand' => 'Visa',
                      'country' => 'US',
                      'customer' => customer_id,
                      'cvc_check' => 'pass',
                      'dynamic_last4' => nil,
                      'exp_month' => 10,
                      'exp_year' => 2015,
                      'funding' => 'credit',
                      'last4' => '4242',
                      'metadata' => {
                      },
                      'name' => nil,
                      'tokenization_method' => nil
                  },
                  'statement_descriptor' => 'myflix standard',
                  'status' => 'succeeded'
              }
          }
      }
    end

    let!(:user) { Fabricate(:user, stripe_id: 'cus_7Ft1EjfovZ9ipp') }

    before do
      post '/stripe_events', event_data
    end

    it 'creates a new payment', :vcr do
      expect(Payment.count).to be 1
    end

    it 'associates the payment with the user', :vcr do
      expect(Payment.last.user).to eq(user)
    end

    it 'creates a payment with the amount 999', :vcr do
      expect(Payment.last.amount).to eq(999)
    end

    it 'creates a payment with the reference_id', :vcr do
      expect(Payment.last.reference_id).to eq('ch_171NFkFsBqZq4amV41bQYS9B')
    end
  end
end