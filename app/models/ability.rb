class Ability
  include CanCan::Ability

  def initialize(user)

    list = {}
    PermissionsSubcategory.all.each do |subcategory|
        list[subcategory.name] = subcategory.id
    end
    
    user ||= User.new
    ######################################################################################
    # PROVINCES | CONFIGURACION
    ######################################################################################
    province = user.permissions_user.find_by_permissions_subcategory_id(list['Provincias'])
    if !province.nil?
        if province.p_create
            can :create, Province
        end

        if province.p_view
            can :read, Province
        end

        if province.p_modify
            can :update, Province
        end

        if province.p_delete
            can :destroy, Province
        end
    end
    ######################################################################################
    # COMPANIES | CONFIGURACION
    ######################################################################################
    company = user.permissions_user.find_by_permissions_subcategory_id(list['Companias']) 
    if !company.nil?
         # Default values, available for all
        can [:manage], Company

        # Not available actions
        cannot [:create, :destroy], Company

        if !company.p_view
            cannot :read, Company
        end

        if !company.p_modify
            cannot :update, Company
        end

    end
    ######################################################################################
    # CANTONS | CONFIGURACION
    ######################################################################################
    canton = user.permissions_user.find_by_permissions_subcategory_id(list['Cantones'])
    if !canton.nil?
        if canton.p_create
            can :create, Canton
        end

        if canton.p_view
            can :read, Canton
        end

        if canton.p_modify
            can :update, Canton
        end

        if canton.p_delete
            can :destroy, Canton
        end
    end
    ######################################################################################
    # DISTRICTS | CONFIGURACION
    ######################################################################################
    district = user.permissions_user.find_by_permissions_subcategory_id(list['Distritos'])
    if !district.nil?
        if district.p_create
            can :create, District
        end

        if district.p_view
            can :read, District
        end

        if district.p_modify
            can :update, District
        end

        if district.p_delete
            can :destroy, District
        end
    end
    ######################################################################################
    # EMPLOYEES | CONFIGURACION
    ######################################################################################
    employee = user.permissions_user.find_by_permissions_subcategory_id(list['Empleados'])
    if !employee.nil?

        # Default values, available for all
        can [:manage], Employee

        # Not available actions
        cannot [:create, :destroy], Employee

        if !employee.p_view
            cannot [:read], Employee
        end

        if !employee.p_modify
            cannot [:update], Employee
        end
        can [:update], Employee
    end
    ######################################################################################
    # DEPARTMENTS | CONFIGURACION
    ######################################################################################
    department = user.permissions_user.find_by_permissions_subcategory_id(list['Departamentos'])
    if !department.nil?
        if department.p_create
            can :create, Department
        end

        if department.p_view
            can :read, Department
        end

        if department.p_modify
            can :update, Department
        end

        if department.p_delete
            can :destroy, Department
        end
    end
    ######################################################################################
    # POSITIONS | CONFIGURACION
    ######################################################################################
    position = user.permissions_user.find_by_permissions_subcategory_id(list['Puestos'])
    if !position.nil?
        if position.p_create
            can :create, Position
        end

        if position.p_view
            can :read, Position
        end

        if position.p_modify
            can :update, Position
        end

        if position.p_delete
            can :destroy, Position
        end
    end
    ######################################################################################
    # TASKS | CONFIGURACION
    ######################################################################################
    task = user.permissions_user.find_by_permissions_subcategory_id(list['Labores'])
    if !task.nil?

        # Default values, available for all
        can [:tasksfb, :load_cc, :fetch_tasks], Task

        # Not available actions
        cannot [:create, :destroy, :update], Task

        if task.p_view
            can :read, Task
        end
    end
    ######################################################################################
    # DEDUCTIONS | CONFIGURACION
    ######################################################################################
    deduction = user.permissions_user.find_by_permissions_subcategory_id(list['Deducciones'])
    if !deduction.nil?

        # All default values, available for all
        can :manage, [Deduction]

        if !deduction.p_create
            cannot :create, Deduction
        end

        if !deduction.p_view
            cannot :read, Deduction
        end

        if !deduction.p_modify
            cannot [:update], Deduction
        end

        if !deduction.p_delete
            cannot :destroy, Deduction
        end
    end
    ######################################################################################
    # WORK BENEFITS | CONFIGURACION
    ######################################################################################
    work_benefit = user.permissions_user.find_by_permissions_subcategory_id(list['Prestaciones'])
    if !work_benefit.nil?

        # All default values, available for all
        can :manage, [WorkBenefit]

        if !work_benefit.p_create
            cannot :create, WorkBenefit
        end

        if !work_benefit.p_view
            cannot :read, WorkBenefit
        end

        if !work_benefit.p_modify
            cannot :update, WorkBenefit
        end

        if !work_benefit.p_delete
            cannot :destroy, WorkBenefit
        end
    end
    ######################################################################################
    # CENTRO DE COSTOS | CONFIGURACION
    ######################################################################################
    centro_de_costo = user.permissions_user.find_by_permissions_subcategory_id(list['Centro de Costos'])
    if !centro_de_costo.nil?

        # All default values, available for all
        can :manage, [CentroDeCosto]

        # Not available actions
        cannot [:create, :destroy, :update], CentroDeCosto

        if !centro_de_costo.p_view
            cannot :read, CentroDeCosto
        end
    end
    ######################################################################################
    # LEADGER ACCOUNTS | CONFIGURACION
    ######################################################################################
    ledger_account = user.permissions_user.find_by_permissions_subcategory_id(list['Cuentas Contables'])
    if !ledger_account.nil?

        # Default values, available for all
        can [:manage], LedgerAccount

        # Not available actions
        cannot [:create, :update, :destroy], LedgerAccount

        if !ledger_account.p_view
            cannot :read, LedgerAccount
        end
    end
    ######################################################################################
    # OTHER SALARIES | CONFIGURACION
    ######################################################################################
    other_salary = user.permissions_user.find_by_permissions_subcategory_id(list['Otros Salarios'])
    if !other_salary.nil?

        # Default values, available for all
        can [:manage], OtherSalary

        if !other_salary.p_create
            cannot :create, OtherSalary
        end

        if !other_salary.p_view
            cannot :read, OtherSalary
        end

        if !other_salary.p_modify
            cannot :update, OtherSalary
        end

        if !other_salary.p_delete
            cannot :destroy, OtherSalary
        end
    end
    ######################################################################################
    # OCCUPATIONS | CONFIGURACION
    ######################################################################################
    occupation = user.permissions_user.find_by_permissions_subcategory_id(list['Ocupaciones'])
    if !occupation.nil?
        if occupation.p_create
            can :create, Occupation
        end

        if occupation.p_view
            can :read, Occupation
        end

        if occupation.p_modify
            can :update, Occupation
        end

        if occupation.p_delete
            can :destroy, Occupation
        end
    end
    ######################################################################################
    # MEANS OF PAYMENTS | CONFIGURACION
    ######################################################################################
    means_of_payment = user.permissions_user.find_by_permissions_subcategory_id(list['Medios de Pago'])
    if !means_of_payment.nil?
        if means_of_payment.p_create
            can :create, MeansOfPayment
        end

        if means_of_payment.p_view
            can :read, MeansOfPayment
        end

        if means_of_payment.p_modify
            can :update, MeansOfPayment
        end

        if means_of_payment.p_delete
            can :destroy, MeansOfPayment
        end
    end
    ######################################################################################
    # PAYMENTS FREQUENCIES | CONFIGURACION
    ######################################################################################
    payment_frequency = user.permissions_user.find_by_permissions_subcategory_id(list['Frecuencias de Pago'])
    if !payment_frequency.nil?
        if payment_frequency.p_create
            can :create, PaymentFrequency
        end

        if payment_frequency.p_view
            can :read, PaymentFrequency
        end

        if payment_frequency.p_modify
            can :update, PaymentFrequency
        end

        if payment_frequency.p_delete
            can :destroy, PaymentFrequency
        end
    end
    ######################################################################################
    # TYPE OF PERSONNEL ACTIONS | CONFIGURACION
    ######################################################################################
    type_of_personnel_action = user.permissions_user.find_by_permissions_subcategory_id(list['Tipos de Acciones del Personal'])
    if !type_of_personnel_action.nil?
        if type_of_personnel_action.p_create
            can :create, TypeOfPersonnelAction
        end

        if type_of_personnel_action.p_view
            can :read, TypeOfPersonnelAction
        end

        if type_of_personnel_action.p_modify
            can :update, TypeOfPersonnelAction
        end

        if type_of_personnel_action.p_delete
            can :destroy, TypeOfPersonnelAction
        end
    end
    ######################################################################################
    # PAYROLL TYPES | CONFIGURACION
    ######################################################################################
    payroll_type = user.permissions_user.find_by_permissions_subcategory_id(list['Tipos de Planillas'])
    if !payroll_type.nil?
        if payroll_type.p_create
            can :create, PayrollType
        end

        if payroll_type.p_view
            can :read, PayrollType
        end

        if payroll_type.p_modify
            can :update, PayrollType
        end

        if payroll_type.p_delete
            can :destroy, PayrollType
        end
    end
    ######################################################################################
    # USERS | CONFIGURACION
    ######################################################################################
    users = user.permissions_user.find_by_permissions_subcategory_id(list['Usuarios'])
    if !users.nil?

        # Default values, available for all
        can [:manage], User

        # Not available actions
        cannot [:create, :destroy], User

        if !users.p_view
            cannot :read, User
        end

        if !users.p_modify
            cannot [:update, :permissions, :save_permissions], User
        end
    end
    ######################################################################################
    # PAYROLLS | PROCESOS
    ######################################################################################
    payroll = user.permissions_user.find_by_permissions_subcategory_id(list['Planillas'])
    if !payroll.nil?

        # Default values, available for all
        can [:manage], [Payroll, PayrollLog]

        if !payroll.p_create
            cannot :create, [Payroll, PayrollLog]
        end

        if !payroll.p_view
            cannot [:read, :get_activas, :get_inactivas], Payroll
            cannot [:read], PayrollLog
        end

        if !payroll.p_modify
            cannot :update, [Payroll, PayrollLog]
        end

        if !payroll.p_delete
            cannot :destroy, [Payroll, PayrollLog]
        end

        if !payroll.p_close
            cannot :close_payroll, Payroll
        end

        if !payroll.p_accounts
            cannot :send_to_firebird, Payroll
        end
    end
    ######################################################################################
    # DETAIL PERSONNEL ACTIONS | PROCESOS
    ######################################################################################
    detail_personnel_action = user.permissions_user.find_by_permissions_subcategory_id(list['Acciones de Personal'])
    if !detail_personnel_action.nil?
        if detail_personnel_action.p_create
            can :create, DetailPersonnelAction
        end

        if detail_personnel_action.p_view
            can :read, DetailPersonnelAction
        end

        if detail_personnel_action.p_modify
            can :update, DetailPersonnelAction
        end

        if detail_personnel_action.p_delete
            can :destroy, DetailPersonnelAction
        end

        if detail_personnel_action.p_close
        end

        if detail_personnel_action.p_accounts
        end
    end
    ######################################################################################
    # PAYMENT PROOF EMPLOYEES | REPORTES
    ######################################################################################
    payment_proof_employee = user.permissions_user.find_by_permissions_subcategory_id(list['Comprobante pago Trabajadores'])
    if !payment_proof_employee.nil?

        # Default values, available for all
        can [:payment_proof_employee_pdf, :payment_proof_employee_xls], User

        if !payment_proof_employee.p_pdf
            cannot [:payment_proof_employee_pdf], User
        end

        if !payment_proof_employee.p_exel
            cannot [:payment_proof_employee_xls], User
        end
    end
    ######################################################################################
    # GENERAL PROOF OF PAYMENT | REPORTES
    ######################################################################################
    general_proof_payments = user.permissions_user.find_by_permissions_subcategory_id(list['Comprobante General de Pago'])
    if !general_proof_payments.nil?
        
        # Default values, available for all
        can [:general_proof_payments_pdf, :general_proof_payments_xls], User

        if !general_proof_payments.p_pdf
            cannot [:general_proof_payments_pdf], User
        end

        if !general_proof_payments.p_exel
            cannot [:general_proof_payments_xls], User
        end
    end
    ######################################################################################
    # TASK BY PAYMENT TYPE | REPORTES
    ######################################################################################
    task_type_payment = user.permissions_user.find_by_permissions_subcategory_id(list['Labores por Tipo de Pago'])
    if !task_type_payment.nil?
        
        # Default values, available for all
        can [:task_type_payment_pdf, :task_type_payment_xls], User

        if !task_type_payment.p_pdf
            cannot [:task_type_payment_pdf], User
        end

        if !task_type_payment.p_exel
            cannot [:task_type_payment_xls], User
        end        
    end
    
  end
end
