class PayrollLog < ActiveRecord::Base
  belongs_to :payroll
  belongs_to :task
  belongs_to :costs_center
  has_many :payroll_histories, :dependent => :destroy
  
  accepts_nested_attributes_for :payroll_histories, :allow_destroy => true, :reject_if => :histories_rejectable?
  attr_accessible :id, :payroll_id, :payroll_histories_attributes, :payroll_date, :payroll_total, :continue_editing, :performance, :exchange_rate
  attr_accessor :continue_editing, :performance

  def self.history(id)
  	
    @employees = Entity.joins(:employee => {:payroll_employees => :payroll_history})
    .where('payroll_histories.payroll_log_id = ?', id)
    .select('DISTINCT employees.id, entities.name, entities.surname').order('entities.surname')

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

  def self.employees_data(id)

    obj = {:employees => []}
    objE = {}
    dta = {}
    @employees = Entity.joins(:employee => {:payroll_employees => :payroll_history})
      .where('payroll_histories.payroll_log_id = ?', id)
      .select('DISTINCT employees.id, entities.name, entities.surname').order('entities.surname')

    @employees.each do |em|
      @history = PayrollHistory.includes(:payroll_employees, :costs_center)
        .where('payroll_employees.employee_id = ? and payroll_histories.payroll_log_id = ?', em.id, id)
        .select('payroll_histories.id, payroll_histories.created_at, payroll_histories.time_worked, costs_centers.name_cc, payroll_histories.payroll_type')
        .order('payroll_histories.payroll_date')
      objE[:name] = "#{em.name} #{em.surname}"
      objE[:id] = em.id
      objE[:add] = []
      objE[:data] = []

      @history.each do |h|
        a = {}
        a[:identification] = h.id
        a[:type_payment] = h.payment_type.present? ? h.payment_type.name.to_s : ''
        a[:type_payment_factor] = h.payment_type.present? ? h.payment_type.factor : ''
        a[:date] = h.payroll_date.strftime("%d/%m/%Y")
        a[:time_worked] = h.time_worked
        a[:performance] = h.performance
        a[:subtotal] = h.total
        a[:cc] = h.costs_center
        a[:task] = h.task
        a[:old] = true
        objE[:data] << a
      end
      obj[:employees] << objE
      objE = {}
    end
    obj
  end
  
  def self.get_employee_list(employees_list)
    entities = Entity.joins(:employee)
      .select("employees.id, employees.number_employee, entities.name, entities.surname")
      .where("employees.id in (?)", employees_list)
  end

  # NEW
  def self.search_employee(employee_name, employee_code, page, per_page)
    entities = Entity.joins(:employee)
      .select("employees.id, employees.number_employee, entities.name, entities.surname")
    entities = entities.where("entities.name like ?", "%#{employee_name}%") if employee_name.present?
    entities = entities.where("employees.number_employee like ?", "%#{employee_code}%") if employee_code.present?
    entities = entities.paginate(:page => page, :per_page => per_page)
  end

  # NEW 
  def self.search_cost(cc_name, cc_code, company_id, page, per_page)
    cc = CostsCenter.select("*")
    cc = cc.where("icost_center like ?", "%#{cc_code}%") if cc_code.present?
    cc = cc.where("name_cc like ?", "%#{cc_name}%") if cc_name.present?
    cc = cc.paginate(:page => page, :per_page => per_page)
  end

  # NEW
  def self.search_task(task_name, task_code, task_iactivity, page, per_page)
    tasks = Task.select("*")
    tasks = tasks.where("ntask like ?", "%#{task_name}%") if task_name.present?
    tasks = tasks.where("itask like ?", "%#{task_code}%") if task_code.present?
    tasks = tasks.where("iactivity = ?", task_iactivity) if task_iactivity.present?
    tasks = tasks.paginate(:page => page, :per_page => per_page)
  end

  def self.delete_employee_to_payment(employee_id, payroll_history_id)
    ph = PayrollHistory.find(payroll_history_id)
    newTotal = ph.payroll_log.payroll_total.to_i - ph.total.to_i
    ph.payroll_log.payroll_total = newTotal
    ph.payroll_log.save
    PayrollEmployee.find_by_payroll_history_id_and_employee_id(payroll_history_id, employee_id).destroy()
  end

  private

  def histories_rejectable?(att)
    att["time_worked"].blank? && new_record? &&
    att["costs_center_id"].blank? && new_record? && 
    att["payment_type_id"].blank? && new_record?
  end

end
