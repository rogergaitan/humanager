class PaymentType < ActiveRecord::Base
  attr_accessible :factor, :name, :contract_code, :payment_type, :performance_unit, :company_id

  scope :all_payment_types, where('state = ?', CONSTANTS[:PAYROLLS_STATES]['ACTIVE'])
  
  def self.find_by_company_id(company_id)
    where(company_id: company_id)
  end
  
  def self.sync_fb
    labtdctos = Labtdcto.select([:iemp, :itdcontrato, :ntdcontrato, :nunidadrec, :itdcalculo])
    
    affected_records = 0
    
    labtdctos.each do |labtdcto|
      #seach for both fields to find unique payment type
      if PaymentType.where(company_id: labtdcto.iemp, contract_code: labtdcto.itdcontrato).empty?
        payment_type = PaymentType.new(company_id:  labtdcto.iemp, contract_code: labtdcto.itdcontrato,
                                      name: labtdcto.ntdcontrato, performance_unit: labtdcto.nunidadrec,
                                      factor: labtdcto.itdcalculo)
        
        if payment_type.save
          affected_records += 1  
        else
          payment_type.errors.each do |error|
            Rails.logger.error "Error creating payment type #{error}" 
          end
        end
      else
        payment_type = PaymentType.where(company_id: labtdcto.iemp, contract_code: labtdcto.itdcontrato).first
        payment_type_params = {name: labtdcto.ntdcontrato, performance_unit: labtdcto.nunidadrec,
                                                   factor: labtdcto.itdcalculo}
    
        if payment_type.update_attributes(payment_type_params)
          affected_records +=1
        end
      end
    end
    affected_records
  end

end
