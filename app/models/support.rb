require "concerns/encodable"

class Support < ActiveRecord::Base
  include Encodable
  attr_accessible :itdsop, :ntdsop, :smask
  
  def self.sync_fb
    
    created_records = 0
    updated_records = 0
    abamtdsops = Abamtdsop.select("itdsop, ntdsop, smask").where(bvisible: "T")
    
    abamtdsops.each do |abamtdsop|
      itdsop = abamtdsop.itdsop
      ntdsop =  firebird_encoding(abamtdsop.ntdsop)
      smask = firebird_encoding(abamtdsop.smask)
      
      if Support.where(itdsop:  itdsop).empty?
        support = Support.new(itdsop: itdsop, ntdsop: ntdsop, smask: smask)
        if support.save
          created_records += 1
        else 
          support.errors.each do |error|
            Rails.logger "Error creando soporte #{itdsop}, #{error}"
          end
        end
      else
        support = Support.find_by_itdsop(itdsop)
        params = { 
          ntdsop: ntdsop, 
          smask: smask
        }
        updated_records += 1 if support.update_attributes(params)
      end
    end
    
    sync_data = {}
    sync_data[:notice] = ["#{I18n.t('helpers.titles.sync').capitalize}: #{created_records}
                          #{I18n.t('helpers.titles.tasksfb_update')}: #{updated_records}"]
    return sync_data
  end
end
