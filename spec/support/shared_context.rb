RSpec.shared_context 'credit card charge submitted' do
  let(:success) do
    return true if not block_given?
    yield
  end
  let(:error_message) do
    return nil if not block_given?
    yield
  end
  before do
    charge_response = double(:charge, successful?: success, error_message: error_message)
    expect(StripeWrapper::Charge).to receive(:create).and_return(charge_response)
  end
end

RSpec.shared_context 'credit card charge not submitted' do
  before do
    allow(StripeWrapper::Charge).to receive_messages(create: nil)
  end
end