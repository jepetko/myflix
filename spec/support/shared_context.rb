RSpec.shared_context 'stripe customer creation submitted' do
  let(:success) do
    return true if not block_given?
    yield
  end
  let(:error_message) do
    return nil if not block_given?
    yield
  end
  let(:customer_id) do
    return nil if not block_given?
    yield
  end
  before do
    customer_response = double(:customer, successful?: success, error_message: error_message, customer_id: customer_id)
    expect(StripeWrapper::Customer).to receive(:create).and_return(customer_response)
  end
end

RSpec.shared_context 'stripe customer creation not submitted' do
  before do
    allow(StripeWrapper::Customer).to receive_messages(create: nil)
  end
end