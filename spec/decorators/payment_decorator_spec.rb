require 'spec_helper'

describe PaymentDecorator do

  describe '#amount' do
    it 'formats the amount in euro' do
      payment = Fabricate(:payment, amount: 333)
      expect(payment.decorate.amount).to eq '3.33 €'
    end
  end

end