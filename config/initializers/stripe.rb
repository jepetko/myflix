Rails.configuration.stripe = {
    :publishable_key => Rails.application.secrets.stripe_publishable_key,
    :secret_key      => Rails.application.secrets.stripe_secret_key
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    stripe_obj = event.data.object
    user = User.find_by(stripe_id: stripe_obj.customer)
    Payment.create(user: user, amount: stripe_obj.amount, reference_id: stripe_obj.id)
  end

end