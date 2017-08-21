require 'concerns/encodable'

class Creditor < ActiveRecord::Base
  include Encodable
  
  attr_accessible :name, :creditor_id
  
  def self.sync_fb
    abanits = Abanit.where bproveedor: "T"
    created_records = 0
    updated_records = 0
    sync_data = {}
    
    abanits.each do |abanit|
      
      creditor_id = abanit.init
      name = firebird_encoding abanit.ntercero
      
      if Creditor.where(creditor_id: creditor_id).empty?
        
        creditor = Creditor.new creditor_id: creditor_id, name: name
        if creditor.save
          created_records += 1
        else
          creditor.errors.each do |error|
            Rails.logger.error  "Error creando acreedor #{creditor_id}, #{error}"
          end
        end
      else
        creditor = Creditor.find_by_creditor_id creditor_id
        creditor.name = name
        
        if creditor.save
          updated_records +=1  
        end
      end
    end
      sync_data[:notice] = ["#{I18n.t('helpers.titles.sync').capitalize}: #{created_records}
                                                  #{I18n.t('helpers.titles.tasksfb_update')}: #{updated_records}"]
  end
  
end
