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
    charge_response = double(:charge)
    charge_response.stub(:successful?).and_return(success)
    charge_response.stub(:error_message).and_return(error_message)
    StripeWrapper::Charge.should_receive(:create).and_return(charge_response)
  end
end

RSpec.shared_context 'credit card charge not submitted' do
  before do
    StripeWrapper::Charge.stub(:create).as_null_object
  end
end