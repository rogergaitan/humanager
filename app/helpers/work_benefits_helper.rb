module WorkBenefitsHelper
  def state_helper(state)
    if state == :active
      "Si"
    else
      "No"
    end
  end
  
  def work_benefits_value_helper(work_benefit)
    if work_benefit.individual
      "Individual"
    elsif work_benefit.calculation_type == :percentage
      "#{work_benefit.work_benefits_value}%"
    elsif work_benefit.calculation_type == :fixed
      "#{work_benefit.currency.try :symbol}#{work_benefit.work_benefits_value}"
    end 
  end
  
end
