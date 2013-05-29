class PayrollHistory < ActiveRecord::Base
  belongs_to :task
  belongs_to :centro_de_costo
  belongs_to :payroll_log
  has_many :payroll_employees, :dependent => :destroy
  has_many :employees, :through => :payroll_employees
  attr_accessible :time_worked, :task_id, :centro_de_costo_id, :payment_type, 
  		:payroll_log_id, :employee_ids, :total, :task_total


	def self.list_to_oprpla5_detalle(payroll_log_id)

		list_objects = []
		list_result = []

		PayrollHistory.where('payroll_log_id = ?', payroll_log_id).each do |ph|

			unless ph.task_id.blank?

				count = ph.payroll_employees.count
				payment_type_id = ''
				index = ''
				object = {}
				object2 = {}

				# 1 si es ordinario, 2 extra, 3 doble (tipo de pago)
				case ph.payment_type.to_s
		            when CONSTANTS[:PAYMENT][0]['name'].to_s # Ordinario
		            	payment_type_id = 1
		            when CONSTANTS[:PAYMENT][1]['name'].to_s # Extra
		            	payment_type_id = 2
		            when CONSTANTS[:PAYMENT][2]['name'].to_s # Doble
		            	payment_type_id = 3
          		end # end case

				object['task_id'] = ph.task_id
				object['centro_de_costo_id'] = ph.centro_de_costo_id
				object['payment_type'] = payment_type_id
				object2['task_id'] = ph.task_id
				object2['centro_de_costo_id'] = ph.centro_de_costo_id
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
