module DeductionsHelper
  def state_helper(state)
    if state == :active
      "Si"
    else
      "No"
    end
  end
  
  def deduction_value_helper(deduction)
    if deduction.individual
      "Individual"
    elsif deduction.calculation_type == :percentage
      "#{deduction.deduction_value}%"
    elsif deduction.calculation_type == :fixed
      "#{deduction.currency.try :symbol}#{deduction.deduction_value}"
    end 
  end
   
end
