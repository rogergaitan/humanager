require 'concerns/encodable'

class CostsCenter < ActiveRecord::Base
  include Encodable
  
  attr_accessible :icc_father, :icost_center, :company_id, :name_cc, :iactivity

  belongs_to :company
  has_many :companies
  
  has_many :other_payments
  has_many :departments
  has_many :payroll_logs
  has_many :work_benefits

  before_destroy :confirm_presence_of_children
  before_update :confirm_is_not_parent
  
  def self.sync_fb
    
    created_records = 0
    updated_records = 0
    empmaest = Empmaestcc.select('iemp, icc, ncc, iccpadre, iactividad').order('iemp')
    
    empmaest.each do |costsCenters|
      cc = CostsCenter.where("icost_center = ? and icc_father = ? and company_id = ?", 
        costsCenters.icc, costsCenters.iccpadre.to_s, costsCenters.iemp).first

      if cc.nil?
        new_cc = CostsCenter.create(
          :company_id => costsCenters.iemp, 
          :icost_center => firebird_encoding(costsCenters.icc.to_s), 
          :name_cc => firebird_encoding(costsCenters.ncc.to_s), 
          :icc_father => firebird_encoding(costsCenters.iccpadre.to_s),
          :iactivity => firebird_encoding(costsCenters.iactividad.to_s)
        )

        if new_cc.save
          created_records += 1
        else
          new_cc.errors.each do |error|
            Rails.logger.error "Error creando centro de costos: #{costsCenters.icc}"
          end
        end
      else
        # UPDATE
        params = {
          :costs_center => {
            :company_id => costsCenters.iemp,
            :name_cc => firebird_encoding(costsCenters.ncc.to_s),
            :icc_father => firebird_encoding(costsCenters.iccpadre.to_s)
          }
        }
        updated_records += 1 if cc.update_attributes(params[:costs_center])
      end
    end
    
    syn_data = {}
    syn_data[:notice] = ["#{I18n.t('helpers.titles.sync').capitalize}: #{created_records} 
                          #{I18n.t('helpers.titles.tasksfb_update')}: #{updated_records}"]
    return syn_data
  end
  
  protected
  
  def confirm_presence_of_children
    @icost_center = CostsCenter.find("#{id}")
    unless CostsCenter.where("icc_father = ?", @icost_center.icost_center).empty?
      errors.add(:base, "El elemento que esta intentando eliminar tiene hijos asociados")
      false
    end
  end
  
  def confirm_is_not_parent
  end
  
end
