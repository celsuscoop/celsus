module ApplicationHelper
  def number_to_number(number)
    number_to_currency(number, :unit => "", :separator => ",")
  end
end
