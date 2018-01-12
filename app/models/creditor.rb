require 'concerns/encodable'

class Creditor < ActiveRecord::Base
  include Encodable
  
  attr_accessible :name, :creditor_id
  
  def self.sync_fb

    created_records = 0
    updated_records = 0
    abanits = Abanit.where(bproveedor: "T")
    
    abanits.each do |abanit|
      
      creditor_id = abanit.init
      name = firebird_encoding(abanit.ntercero)
      
      if Creditor.where(creditor_id: creditor_id).empty?
        
        creditor = Creditor.new(creditor_id: creditor_id, name: name)
        if creditor.save
          created_records += 1
        else
          creditor.errors.each do |error|
            Rails.logger.error  "Error creando acreedor #{creditor_id}, #{error}"
          end
        end
      else
        creditor = Creditor.find_by_creditor_id(creditor_id)
        creditor.name = name
        updated_records +=1 if creditor.save
      end
    end

    sync_data = {}
    sync_data[:notice] = ["#{I18n.t('helpers.titles.sync').capitalize}: #{created_records}
                          #{I18n.t('helpers.titles.tasksfb_update')}: #{updated_records}"]
    return sync_data
  end
  
end
