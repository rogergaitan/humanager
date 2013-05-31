class ReportsController < ApplicationController
  	# Comprobante Pago trabajadores
	respond_to :html, :json, :js

	def index
  		@payrolls = Payroll.where('state = ?', 0)
  		@department = Department.all
  		@superior = Employee.superior
  		@employees = Employee.order_employees
  	end

	def search_payrolls
	    @payrolls = Payroll.search_payrolls_to_reports(params[:start_date], params[:end_date], params[:page], 5)
    	respond_with @payrolls
  	end

end
