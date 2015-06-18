class PayrollLog < ActiveRecord::Base
  belongs_to :payroll
  belongs_to :task
  belongs_to :costs_center
  has_many :payroll_histories, :dependent => :destroy
  
  accepts_nested_attributes_for :payroll_histories, :allow_destroy => true, :reject_if => proc { |attributes| attributes["time_worked"].blank? && attributes["costs_center_id"].blank? }
  attr_accessible :id, :payroll_id, :payroll_histories_attributes, :payroll_date, :payroll_total, :continue_editing
  attr_accessor :continue_editing

  def self.history(id)
  	
  	@employees = Entity.joins(:employee => {:payroll_employees => :payroll_history})
  	.where('payroll_histories.payroll_log_id = ?', id)
    .select('employees.id, entities.name, entities.surname').order('entities.surname')

    result = {}
    employee_detail = {}
    
    @employees.each do |em|
      @history = PayrollHistory.includes(:payroll_employees, :costs_center)
      .where('payroll_employees.employee_id = ? and payroll_histories.payroll_log_id = ?', em.id, id)
      .select('payroll_histories.id, payroll_histories.created_at, payroll_histories.time_worked, costs_centers.name_cc, payroll_histories.payroll_type')
      .order('payroll_histories.payroll_date')
      employee_detail = ["#{em.id}", "#{em.name} #{em.surname}"]
      result[employee_detail] = @history
    end
    result
  end

  def self.search_task(search_task_name, page, per_page = nil)
    @tasks = Task.where(" tasks.ntask like '%#{search_task_name}%' " )
    .paginate(:page => page, :per_page => 5)
  end

  def self.search_cost(search_cost_name, company_id, page, per_page = nil)
    @costs = CostsCenter.where(" costs_centers.icompany = '#{company_id}' and costs_centers.name_cc like '%#{search_cost_name}%' and costs_centers.icost_center != '' ")
    .paginate(:page => page, :per_page => 5)
  end

  def self.search_employee(search_employee_name, page, per_page = nil)
    @entities = Entity.where(" entities.name like '%#{search_employee_name}%' ")
    .paginate(:page => page, :per_page => 5)
  end

  def self.delete_employee_to_payment(employee_id, payroll_history_id)
    PayrollEmployee.find_by_payroll_history_id_and_employee_id(payroll_history_id, employee_id).destroy()
  end

end