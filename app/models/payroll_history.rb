class PayrollHistory < ActiveRecord::Base
  belongs_to :task
  belongs_to :costs_center
  belongs_to :payroll_log
  belongs_to :payment_type
  
  has_many :payroll_employees, :dependent => :destroy
  has_many :employees, :through => :payroll_employees, :validate => false

  attr_accessible :time_worked, :task_id, :costs_center_id, :payment_type_id,
                  :payroll_log_id, :employee_ids, :total, :task_total, :task_unidad,
                  :payroll_date, :performance

  def self.list_to_oprpla5_detalle(payroll_log_id)

    list_objects = []
    list_result = []

    PayrollHistory.where('payroll_log_id = ?', payroll_log_id).includes(:costs_center).each do |ph|
      
      unless ph.task_id.blank?

        count = ph.payroll_employees.count
        index = ''
        object = {}
        
        object[:itask] = ph.task.itask
        object[:iactivity] = ph.task.iactivity
        object[:costs_center_id] = ph.costs_center.icost_center
        object[:payment_type] = ph.payment_type.contract_code
        object[:factor] = ph.payment_type.factor.to_s
        object2 = object.clone

        if list_objects.include?(object)
          index = list_objects.index(object)
          list_result[index][:time_worked] += (ph.time_worked.to_f * count.to_f)
          list_result[index][:performance] += (ph.performance.to_f * count.to_f)
          list_result[index][:total] += (ph.total.to_f * count.to_f)
        else
          list_objects << object
          object2[:time_worked] = (ph.time_worked.to_f * count.to_f)
          object2[:performance] = (ph.performance.to_f * count.to_f)
          object2[:total] = (ph.total.to_f * count.to_f)
          list_result << object2
        end
      end
    end
    
    list_result
  end
  
  def payroll_currency_type
    payroll_log.payroll.currency.currency_type
  end
  
  def exchange_rate
    payroll_log.exchange_rate
  end

end
