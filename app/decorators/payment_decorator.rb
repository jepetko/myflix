class PaymentDecorator < Draper::Decorator
  delegate_all

  def amount
    amount = read_attribute :amount
    formatted_amount = "%.2f" % (amount.to_f/100)
    "#{formatted_amount} €"
  end
end