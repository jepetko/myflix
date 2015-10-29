module StripeWrapper

  module Base

    def self.included(base)
      base.extend StaticMethods
    end

    attr_reader :status, :error_type, :error_message

    def initialize(status, options={})
      @status = status
      @error_type = options[:error_type]
      @error_message = options[:error_message]
    end

    def successful?
      @status == :success
    end

    module StaticMethods
      def handle_exception(err)
        new :card_error, error_type: err.class.name, error_message: err.message
      end
    end

  end

  class Charge
    include Base

    def initialize(status, options={})
      super status, options
    end

    def self.create(options={})
      begin
        Stripe::Charge.create(card: options[:card],
                              amount: 999,
                              description: options[:description],
                              currency: 'usd')
        new :success
      rescue Stripe::CardError => err
        handle_exception err
      end
    end


  end

  class Customer
    include Base

    attr_reader :customer_id

    def initialize(status, options={})
      super status, options
      @customer_id = options[:customer_id]
    end

    def self.subscribe(options={})
      begin
        customer = Stripe::Customer.create( plan: 'standard',
                                            source: options[:sources],
                                            email: options[:user].email)
        new :success, customer_id: customer.id
      rescue Stripe::CardError => err
        handle_exception err
      end
    end

  end

end