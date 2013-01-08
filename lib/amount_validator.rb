class AmountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    
    	Rails.logger.info "RECORD"
    	Rails.logger.debug record
    	Rails.logger.info "ATTRIBUTE"
    	Rails.logger.debug attribute
    	Rails.logger.info "VALUE"
    	Rails.logger.debug value
      record.errors[attribute] << (options[:message] || "IS NOT A VALUE")
    
  end
end