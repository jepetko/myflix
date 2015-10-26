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
        Stripe::Charge.create(card: options[:card],
                              amount: 999,
                              description: options[:description],
                              currency: 'usd')
        new :success
      rescue Stripe::CardError => err
        new :card_error, error_type: err.class.name, error_message: err.message
      end
    end

  end

end