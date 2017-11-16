require 'active_support/concern'

module CurrencyConverter
  extend ActiveSupport::Concern
  
  module ClassMethods
    #checks if it's necesary to convert currency based on the payroll currency type
    #otherwise just return the current amount
    def check_currency(payroll_currency, other_currency, amount, exchange_rate)
      if payroll_currency != other_currency
        convert_currency(payroll_currency, amount, exchange_rate)
      else
        amount
      end
    end
    
    def convert_currency(currency, amount, exchange_rate)
      if currency == :local
        amount * exchange_rate
      elsif currency == :foreign
        amount / exchange_rate
      end
    end
  end

end
