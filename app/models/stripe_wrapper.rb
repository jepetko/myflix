module StripeWrapper

  class Charge
    attr_reader :status, :error_type, :error_message
    def initialize(status, options={})
      @status = status
      @error_type = options[:error_type]
      @error_message = options[:error_message]
    end

    def successful?
      @status == :success
    end

    def self.create(options={})
      begin
        Stripe::Charge.create(card: options[:card], amount: 999, description: options[:description], currency: 'usd')
        new :success
      rescue Stripe::CardError => err
        new :card_error, error_type: err.class.name, error_message: err.message
      rescue Stripe::RateLimitError, Stripe::InvalidRequestError, Stripe::AuthenticationError, Stripe::APIConnectionError, Stripe::StripeError => err
        # RateLimitError: Too many requests made to the API too quickly
        # InvalidRequestError: Invalid parameters were supplied to Stripe's API
        # AuthenticationError: Authentication with Stripe's API failed (maybe you changed API keys recently)
        # APIConnectionError: Network communication with Stripe failed
        # StripeError: Display a very generic error to the user, and maybe send
        # yourself an email
        Raven.capture_exception(err) if Rails.env.production?
        new :technical_error, error_type: err.class.name, error_message: err.message
      rescue => err
        Raven.capture_exception(err) if Rails.env.production?
        raise err
      end
    end

  end

end