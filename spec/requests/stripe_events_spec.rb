require 'spec_helper'

describe 'Stripe Events', :vcr do

  describe 'charge events' do

    context 'charge succeeded' do

      let(:customer_id) { 'cus_7Ft1EjfovZ9ipp' }
      let(:event_data_charge_succeeded) do
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
      let!(:user) { Fabricate(:user, stripe_id: customer_id) }

      before do
        post '/stripe_events', event_data_charge_succeeded
      end

      it 'creates a new payment' do
        expect(Payment.count).to be 1
      end

      it 'associates the payment with the user' do
        expect(Payment.last.user).to eq(user)
      end

      it 'creates a payment with the amount 999' do
        expect(Payment.last.amount).to eq(999)
      end

      it 'creates a payment with the reference_id' do
        expect(Payment.last.reference_id).to eq('ch_171NFkFsBqZq4amV41bQYS9B')
      end
    end

    context 'charge failed' do

      let(:customer_id) { 'cus_7GsG8JKpcmWy6s' }
      let(:event_data_charge_failed) do
        {
            'id' => 'evt_172KZSFsBqZq4amVbL6Z9EEk',
            'object' => 'event',
            'api_version' => '2015-10-16',
            'created' => 1446379466,
            'data' => {
                'object' => {
                    'id' => 'ch_172KZSFsBqZq4amVVH7BwmoF',
                    'object' => 'charge',
                    'amount' => 999,
                    'amount_refunded' => 0,
                    'application_fee' => nil,
                    'balance_transaction' => nil,
                    'captured' => false,
                    'created' => 1446379466,
                    'currency' => 'eur',
                    'customer' => customer_id,
                    'description' => '',
                    'destination' => nil,
                    'dispute' => nil,
                    'failure_code' => 'card_declined',
                    'failure_message' => 'Your card was declined.',
                    'fraud_details' => {
                    },
                    'invoice' => nil,
                    'livemode' => false,
                    'metadata' => {
                    },
                    'paid' => false,
                    'receipt_email' => nil,
                    'receipt_number' => nil,
                    'refunded' => false,
                    'refunds' => {
                        'object' => 'list',
                        'data' => [

                        ],
                        'has_more' => false,
                        'total_count' => 0,
                        'url' => '/v1/charges/ch_172KZSFsBqZq4amVVH7BwmoF/refunds'
                    },
                    'shipping' => nil,
                    'source' => {
                        'id' => 'card_172KXxFsBqZq4amVYAHVgD0P',
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
                        'exp_month' => 11,
                        'exp_year' => 2017,
                        'fingerprint' => '2oXXqsiTLEoONryH',
                        'funding' => 'credit',
                        'last4' => '0341',
                        'metadata' => {
                        },
                        'name' => nil,
                        'tokenization_method' => nil
                    },
                    'statement_descriptor' => nil,
                    'status' => 'failed'
                }
            },
            'livemode' => false,
            'pending_webhooks' => 1,
            'request' => 'req_7GsKJrwbdT2TGi',
            'type' => 'charge.failed'
        }
      end
      let!(:user) { Fabricate(:user, email: 'failing_user@mailinator.com', stripe_id: customer_id) }

      before do
        post '/stripe_events', event_data_charge_failed
      end

      it 'does not create a payment' do
        expect(Payment.count).to be 0
      end

      it 'locks the account of the user' do
        user.reload
        expect(user).to be_locked
      end

      it 'sends an email' do
        expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
      end
    end

  end
end