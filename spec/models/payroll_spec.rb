require 'rails_helper'

RSpec.describe Payroll, :type => :model do
  
  it "closes payroll" do
    cordobas = Currency.create name: "Cordobas", symbol: "C$"
    cordobas.currency_type = :local
    cordobas.save
    dollars = Currency.create name: "Dolares", symbol: "U$"
    dollars.currency_type = :foreign
    dollars.save
    
    company = Company.create name: "Rajuanse State", code: 0000
    
    ledger_account = LedgerAccount.create iaccount: "12", naccount: "PROPIEDAD, PLANTA Y EQUIPO", ifather: "1"
    
    payroll_type = PayrollType.new(company_id: company.id, ledger_account_id: ledger_account.id, state: true,
                                   description: "test payroll", cod_doc_payroll_support: 1, mask_doc_payroll_support: "CJ-##",
                                   cod_doc_accounting_support_mov: 1, mask_doc_accounting_support_mov: "SB-@@", 
                                   calendar_color: "#00b9ff", allow_register_from_app: true)
    payroll_type.payroll_type = :plant
    payroll_type.save
  
    payroll = Payroll.create!(company_id: company.id, payroll_type_id: payroll_type.id, start_date: "01/10/2017", end_date: "15/10/2017",
                        payment_date: "15/10/2017", state: true, currency_id: cordobas.id)
    
    payroll_log = PayrollLog.create! payroll_id: payroll.id, payroll_date: "15/10/2017"
    
    costs_center = CostsCenter.create company_id: company.id, icost_center: "10302", name_cc: "Area en producción", icc_father: "103", iactivity: "1"
    task = Task.create iactivity: "1", itask: "0040", ntask: "Acarreo de plantas", nunidad: "Dia", currency_id: cordobas.id, cost: 100, nactivity: "Café"
    payment_type = PaymentType.create name: "Pago por labor", factor: 2, contract_code: "1"
    
    payroll_history = PayrollHistory.new task_id: task.id, payroll_log_id: payroll_log.id, payment_type_id: payment_type.id, 
                                        time_worked: "2", task_total: 300, total: 1500, performance: "2", task_unidad: "2"
    payroll_history.costs_center_id = costs_center.id
    payroll_history.save
    
    entity = Entity.create name: "Jose Benito", surname: "Cruz Granados", entityid: "4482003620000S"
    employee = entity.create_employee
    
    payroll_log.payroll_histories << payroll_history
    
    other_payment = OtherPayment.new costs_center_id: costs_center.id, ledger_account_id: ledger_account.id, name: "Incentivos", 
                                        amount: 20, constitutes_salary: true, currency_id: cordobas.id, company_id: company.id
    other_payment.other_payment_type = :constant
    other_payment.calculation_type = :fixed
    other_payment.active = true
    other_payment.payroll_type << payroll_type
    other_payment.save
    
    OtherPaymentEmployee.create other_payment_id: other_payment.id, employee_id: employee.id, calculation: 100
                                          
    PayrollEmployee.create! employee_id: employee.id, payroll_history_id: payroll_history.id
    
    Payroll.close_payroll  payroll.id, 30.47
    
    expect(payroll.payroll_log.payroll_total).to eq(1500)
  end
  
  it "converts dollars to cordobas" do
    result = Payroll.convert_currency :local, 1000, 30.47 
    expect(result).to eq(30470.0)
  end
  
  it "converts cordobas to dollars" do
    result = Payroll.convert_currency :foreign,30470 , 30.47 
    expect(result).to eq(1000)
  end
  
  it "checks if currency convertion from foreign to local is necessary" do
    result = Payroll.check_currency :local, :foreign, 30470, 30.47
    expect(result).to eq(1000)
  end
  
  it "checks if currency convertion from local to foreign is necessary" do
    result = Payroll.check_currency :foreign, :local, 1000, 30.47
    expect(result).to eq(30470.0)
  end
  
  it "checks if currency convertion is not necessary in local currency" do
    result = Payroll.check_currency :local, :local, 30470, 30.47
    expect(result).to eq(30470.0)
  end
  
  it "checks if currency convertion is not necessary in foreign currency" do
    result = Payroll.check_currency :foreign, :foreign, 1000, 30.47
    expect(result).to eq(1000)
  end
  
end
