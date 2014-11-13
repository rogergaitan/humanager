class ChangeDecimalFieldsToCorrectFormat < ActiveRecord::Migration
  def change

  	change_column(:deductions, :amount_exhaust, :decimal, :precision => 10, :scale => 2)
  	change_column(:deduction_employees, :calculation, :decimal, :precision => 10, :scale => 2)
  	change_column(:deduction_payments, :previous_balance, :decimal, :precision => 10, :scale => 2)
  	change_column(:deduction_payments, :payment, :decimal, :precision => 10, :scale => 2)
  	change_column(:deduction_payments, :current_balance, :decimal, :precision => 10, :scale => 2)
  	change_column(:work_benefits, :percentage, :decimal, :precision => 10, :scale => 2)
  	change_column(:work_benefits_payments, :percentage, :decimal, :precision => 10, :scale => 2)
  	change_column(:work_benefits_payments, :payment, :decimal, :precision => 10, :scale => 2)
  	change_column(:payroll_histories, :total, :decimal, :precision => 10, :scale => 2)
  	change_column(:payroll_histories, :task_total, :decimal, :precision => 10, :scale => 2)
  	change_column(:other_salaries, :amount, :decimal, :precision => 10, :scale => 2)
  	change_column(:other_salary_employees, :amount, :decimal, :precision => 10, :scale => 2)
  	change_column(:payroll_logs, :payroll_total, :decimal, :precision => 10, :scale => 2)

  end
end
