class PayrollHistory < ActiveRecord::Base
  belongs_to :task
  belongs_to :costs_center
  belongs_to :payroll_log
  belongs_to :payment_type
  
  has_many :payroll_employees, :dependent => :destroy
  has_many :employees, :through => :payroll_employees, :validate => false
  attr_accessible :time_worked, :task_id, :costs_center_id, :payment_type_id, 
    :payroll_log_id, :employee_ids, :total, :task_total, :task_unidad, :payroll_date, 
    :performance

  # KALFARO
  def self.list_to_oprpla5_detalle(payroll_log_id)

    list_objects = []
    list_result = []

    PayrollHistory.where('payroll_log_id = ?', payroll_log_id).includes(:costs_center).each do |ph|

      unless ph.task_id.blank?

        count = ph.payroll_employees.count
        payment_type_id = ph.payment_type.contract_code
        index = ''
        object = {}
        object2 = {}
        #cost_center_code = CentroDeCosto.where('id = ?', )

        object['itask'] = ph.task.itask
        object['costs_center_id'] = ph.centro_de_costo.icentro_costo
        object['payment_type'] = payment_type_id
        object2['itask'] = ph.task.itask
        object2['costs_center_id'] = ph.centro_de_costo.icentro_costo
        object2['payment_type'] = payment_type_id

        if list_objects.include?(object)
          index = list_objects.index(object)
          list_result[index]['time_worked'] += (ph.time_worked.to_f * count.to_f)
          list_result[index]['total'] += (ph.total.to_f * count.to_f)
        else
          list_objects << object
          object2['time_worked'] = (ph.time_worked.to_f * count.to_f)
          object2['total'] = (ph.total.to_f * count.to_f)
          list_result << object2
        end
      end # End unless
    end # End each PayrollHistory

    list_result
  end

end
