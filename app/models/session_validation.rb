class SessionValidation < ActiveRecord::Base
  attr_accessible :user_id, :model_name_id, :reference_id, :ip_address, :updated_at

  validates :user_id, presence: true
  validates :model_name_id, :presence => true
  validates :reference_id, :presence => true
  validates :ip_address, :presence => true

  def self.validate_session(model, reference_id, user_id, ip_address)

  	modelName = ModelName.find_by_name(model.model_name)
  	sessionValidation = SessionValidation.where(:model_name_id => modelName.id, 
  		:reference_id => reference_id)

  	if sessionValidation.empty?
  		SessionValidation.create(:user_id => user_id, :model_name_id => modelName.id, 
  			:reference_id => reference_id, :ip_address => ip_address)
      return true
  	else
      if check_time(sessionValidation.first.updated_at)
        # Same user & IP
        if sessionValidation.first.user_id == user_id && sessionValidation.first.ip_address == ip_address
          # Update attribute updated_at
          sessionValidation.first.update_attributes(:updated_at => Time.now)
          sessionValidation.first.save
          return true
        else
          # Someone else is editing the same record(Is not the same user & IP)
          return false
        end
      else
        # The time expired, change values
        sessionValidation.first.update_attributes(:user_id => user_id, :ip_address => ip_address, 
          :updated_at => Time.now)
        sessionValidation.first.save
        return true
			end
  	end
  end

  def self.check_time(last_modification)

  	limit_time = CONSTANTS[:VALIDATION_TIME].to_i
  	seconds = (Time.now - last_modification).to_i
		minutes = (seconds/60).to_i
		hours = (minutes/60).to_i
		days = (hours/24).to_i

		if days == 0 && hours == 0 && minutes < limit_time
			return true
		else
			return false
		end
  end

end
