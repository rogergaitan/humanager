require 'concerns/encodable'

class PaymentType < ActiveRecord::Base
  include Encodable
  
  attr_accessible :factor, :name, :contract_code, :payment_type, :payment_unit, :company_id

  # Constants
  STATE_ACTIVE = 'active'.freeze
  STATE_COMPLETED = 'completed'.freeze
  PAYMENT_ORDINARY = 'ordinary'.freeze
  PAYMENT_EXTRA = 'extra'.freeze
  PAYMENT_DOBLE = 'double'.freeze

  scope :all_payment_types, where('state = ?', STATE_ACTIVE)
  
  def self.find_by_company_id(company_id)
    where(company_id: company_id)
  end
  
  def self.sync_fb
    labtdctos = Labtdcto.select([:iemp, :itdcontrato, :ntdcontrato, :nunidadrec, :itdcalculo])
    
    created_records = 0
    updated_records = 0
    sync_data = {}
    
    labtdctos.each do |labtdcto|
      #seach for both fields to find unique payment type
      if PaymentType.where(company_id: labtdcto.iemp, contract_code: labtdcto.itdcontrato).empty?
        
        payment_type = PaymentType.new(company_id:  labtdcto.iemp, contract_code: labtdcto.itdcontrato,
                                          name: labtdcto.ntdcontrato, payment_unit: firebird_encoding(labtdcto.nunidadrec),
                                          factor: labtdcto.itdcalculo)
        
        if payment_type.save
          created_records += 1  
        else
          payment_type.errors.each do |error|
            Rails.logger.error "Error creating payment type #{error}" 
          end
        end
      else
        payment_type = PaymentType.where(company_id: labtdcto.iemp, contract_code: labtdcto.itdcontrato).first
        payment_type_params = {name: labtdcto.ntdcontrato, payment_unit: firebird_encoding(labtdcto.nunidadrec),
                                                           factor: labtdcto.itdcalculo}
    
        if payment_type.update_attributes(payment_type_params)
          updated_records +=1
        end
      end
    end
      sync_data[:notice] = ["#{I18n.t('helpers.titles.sync').capitalize}: #{created_records} 
                                                #{I18n.t('helpers.titles.tasksfb_update')}: #{updated_records}"]
  end
end
