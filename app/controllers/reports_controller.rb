class ReportsController < ApplicationController

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

  def show

    case params[:type].to_s
      
      when CONSTANTS[:REPORTS][0]['PAYMENT_PROOF']
        
        @employees = params[:employees].split(",")
        @payroll = Payroll.find(params[:payroll_id])
        
        respond_to do |format|
          format.pdf do
            pdf = ProofPayEmployeesPDF.new(@payroll, @employees)
            send_data pdf.render, filename: "prueba.pdf",
              type: "application/pdf", disposition: "inline"
          end
        end

      when "2"
        # Code here...

    end # End case



  end # End show

end
