class PaymentDecorator < Draper::Decorator
  include ActionView::Helpers::NumberHelper
  delegate_all

  def amount
    amount = read_attribute(:amount)/100.to_f
    number_to_currency(amount, locale: :de, separator: '.')
  end
end