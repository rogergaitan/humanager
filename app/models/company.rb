# == Schema Information
#
# Table name: companies
#
#  id              :integer          not null, primary key
#  code            :integer
#  name            :string(255)
#  label_reports_1 :text
#  label_reports_2 :text
#  label_reports_3 :text
#  inum            :integer          (Autoincrement number just to send data to Firebird)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Company < ActiveRecord::Base
  attr_accessible :code, :name, :label_reports_1, :label_reports_2, :label_reports_3, 
                  :inum, :page_footer

  has_many :payroll

  has_one :department
  belongs_to :department

  has_one :deduction
  belongs_to :deduction

  has_one :work_benefit
  belongs_to :work_benefit

  belongs_to :payroll_type
  has_many :payroll_type

  belongs_to :costs_center
  has_many :costs_center

  # Sync Companies
  def self.sync_fb
    created_records = 0
    updated_records = 0
    companies = []
    empmaestcc = Empmaestcc.includes(:empagropecuaria)
                           .find(:all, :select =>['iemp', 'ncc'], :conditions => ['icc = ?', ''])
        
    empmaestcc.each do |cfb|

      empagropecuaria_params = {
        :label_reports_1 => cfb.empagropecuaria.srotulorpt1,
        :label_reports_2 => cfb.empagropecuaria.srotulorpt2,
        :label_reports_3 => cfb.empagropecuaria.srotulorpt3,
        :page_footer => cfb.empagropecuaria.sinfopiepagina
      }
            
      if Company.where('code = ?', cfb.iemp).empty?
        new_company_params = { :code => cfb.iemp, :name => "#{cfb.ncc}" }.merge empagropecuaria_params
        new_company = Company.new(new_company_params)

        if new_company.save
          companies << new_company
          created_records += 1
        else
          new_company.errors.each do |error|
            Rails.logger.error "Error Creating Company: #{cfb.ncc}, Description: #{error}"
          end
        end
      else
        # UPDATE
        update_company = Company.find_by_code(cfb.iemp)
        params = { :name => "#{cfb.ncc}"}.merge empagropecuaria_params
        updated_records += 1 if update_company.update_attributes(params)
      end
    end

    companies_fb = {}
    companies_fb[:companies] = companies
    companies_fb[:notice] = ["#{I18n.t('helpers.titles.tasksfb')}: #{created_records} 
                              #{I18n.t('helpers.titles.tasksfb_update')}: #{updated_records}"]
    return companies_fb
  end

end
