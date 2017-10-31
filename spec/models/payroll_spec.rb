require 'rails_helper'

RSpec.describe Payroll, :type => :model do
  
  describe "closing/opening payroll" do
    
    before(:each) do
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
    
      @payroll = Payroll.create!(company_id: company.id, payroll_type_id: payroll_type.id, start_date: "01/10/2017", end_date: "15/10/2017",
                          payment_date: "15/10/2017", state: true, currency_id: cordobas.id)
      
      payroll_log = PayrollLog.create! payroll_id: @payroll.id, payroll_date: "15/10/2017"
      
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
      
      other_payment_foreign_key = OtherPayment.new costs_center_id: costs_center.id, ledger_account_id: ledger_account.id, name: "Incentivos moneda extranjera",
                                                                amount: 40, constitutes_salary: true, currency_id: dollars.id, company_id: company.id
      other_payment_foreign_key.other_payment_type = :constant
      other_payment_foreign_key.calculation_type = :fixed
      other_payment_foreign_key.active = true
      other_payment_foreign_key.payroll_type << payroll_type
      other_payment_foreign_key.save
      
      OtherPaymentEmployee.create other_payment_id: other_payment.id, employee_id: employee.id, calculation: 100
      OtherPaymentEmployee.create other_payment_id: other_payment_foreign_key.id, employee_id: employee.id, calculation: 40
                                            
      PayrollEmployee.create! employee_id: employee.id, payroll_history_id: payroll_history.id
      
      deduction = Deduction.new company_id: company.id, description: "Deduccion estandar", ledger_account_id: ledger_account.id,
                                                            pay_to_employee: true, individual: false, deduction_currency_id: cordobas.id, deduction_value: 500
      deduction.active = true 
      deduction.deduction_type = :constant
      deduction.calculation_type = :fixed
      deduction.payroll_type << payroll_type
      deduction.save
      
      deduction_amount_exhaust = Deduction.new company_id: company.id, description: "Deduccion monto a agotar", ledger_account_id: ledger_account.id,
                                                                                              pay_to_employee: true, individual: false, deduction_currency_id: cordobas.id, deduction_value: 50,
                                                                                              maximum_deduction: 20, maximum_deduction_currency_id: cordobas.id, amount_exhaust: 50,
                                                                                              amount_exhaust_currency_id: cordobas.id
      deduction_amount_exhaust.active = true
      deduction_amount_exhaust.deduction_type = :amount_to_exhaust
      deduction_amount_exhaust.calculation_type = :percentage
      deduction_amount_exhaust.payroll_type << payroll_type
      deduction_amount_exhaust.save
      
      deduction_foreign_currency = Deduction.new company_id: company.id, description: "Deduccion moneda extranjera", ledger_account_id: ledger_account.id,
                                                                                              pay_to_employee: true, individual: true, deduction_currency_id: dollars.id, deduction_value: 50
      deduction_foreign_currency.active = true
      deduction_foreign_currency.deduction_type = :constant
      deduction_foreign_currency.calculation_type = :fixed
      deduction_foreign_currency.payroll_type << payroll_type
      deduction_foreign_currency.save
      
      DeductionEmployee.create deduction_id: deduction.id, employee_id: employee.id, calculation: 100
      DeductionEmployee.create deduction_id: deduction_amount_exhaust.id, employee_id: employee.id, calculation: 100
      DeductionEmployee.create! deduction_id: deduction_foreign_currency.id, employee_id: employee.id, calculation: 20
      
      work_benefit = WorkBenefit.new company_id: company.id, costs_center_id: costs_center.id, name: "Beneficios", currency_id: cordobas.id,
                                                                      work_benefits_value: 50, currency_id: cordobas.id, provisioning: true, individual: false, pay_to_employee: true
      work_benefit.calculation_type = :percentage
      work_benefit.active = true
      work_benefit.payroll_type << payroll_type
      work_benefit.save
      
      work_benefit_foreign_currency = WorkBenefit.new company_id: company.id, costs_center_id: costs_center.id, name: "Beneficios moneda extranjera",
                                                                                                          currency_id: dollars.id, provisioning: false, individual: false, pay_to_employee: true, work_benefits_value: 40
      work_benefit_foreign_currency.calculation_type = :fixed
      work_benefit_foreign_currency.active = true
      work_benefit_foreign_currency.payroll_type << payroll_type
      work_benefit_foreign_currency.save
      
      EmployeeBenefit.create work_benefit_id: work_benefit.id, employee_id: employee.id, completed: false  
    end
    
    it "closes payroll" do      
      Payroll.close_payroll  @payroll.id, "30.47"
      
      expect(@payroll.payroll_log.payroll_total.to_f).to be > 0
    end
  
    it "reopens payroll" do
      Payroll.close_payroll  @payroll.id, "30.47"
      
      Payroll.reopen_payroll @payroll.id
      
      expect(Payroll.where(state: true).count).to eq(1)
      expect(DeductionPayment.count).to eq(0)
      expect(WorkBenefitsPayment.count).to eq(0)
      expect(OtherPaymentPayment.count).to eq(0)
      expect(Deduction.where(state: :completed).count).to eq(0)
      expect(OtherPayment.where(state: :completed).count).to eq(0)
      expect(WorkBenefit.where(state: :completed).count).to eq(0)
    end
    
  end
  
  it "converts dollars to cordobas" do
    result = Payroll.convert_currency :foreign, 1000, 30.47 
    expect(result).to eq(30470.0)
  end
  
  it "converts cordobas to dollars" do
    result = Payroll.convert_currency :local,30470 , 30.47 
    expect(result).to eq(1000)
  end
  
  it "checks if currency convertion from local to foreign is necessary" do
    result = Payroll.check_currency :foreign, :local, 30470, 30.47
    expect(result).to eq(1000)
  end
  
  it "checks if currency convertion from foreign to local is necessary" do
    result = Payroll.check_currency :local, :foreign, 1000, 30.47
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
  
  it "checks deduction amount is not greater than maximum deduction" do
    result = Payroll.check_maximum_deduction 50, 20
    expect(result).to eq(20)
  end
  
  it "checks amount is valid to deduct" do
    result = Payroll.check_maximum_deduction 20, 50
    expect(result).to eq(20)
  end
  
end
