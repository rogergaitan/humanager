class PayrollLog < ActiveRecord::Base
  belongs_to :payroll
  belongs_to :task
  belongs_to :centro_de_costos
  has_many :payroll_histories, :dependent => :destroy
  
  accepts_nested_attributes_for :payroll_histories, :allow_destroy => true, :reject_if => proc { |attributes| attributes["time_worked"].blank? && attributes["centro_de_costo_id"].blank? }
  attr_accessible :payroll_histories_attributes, :payroll_date


  def self.history(id)
  	
  	@employees = Entity.joins(:employee => {:payroll_employees => :payroll_history})
  	.where('payroll_histories.payroll_log_id = ?', id)
  	.select('entities.id, entities.name, entities.surname')

    result = {}
    
    @employees.each do |em|
      @history = PayrollHistory.includes(:payroll_employees, :task, :centro_de_costo)
      .where('payroll_employees.employee_id = ? and payroll_histories.payroll_log_id = ?', em.id, id)
      .select('payroll_histories.created_at, tasks.ntask, payroll_histories.time_worked, centro_de_costo.nombre_cc, payroll_histories.payroll_type')
      result["#{em.name} #{em.surname}"] = @history
    end
    result
  end

end