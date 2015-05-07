class CompaniesController < ApplicationController
  respond_to :html, :json, :js
  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.paginate(:page => params[:page], :per_page => 15).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @companies }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
  end

  # PUT /companies/1
  # PUT /companies/1.json
  def update
    @company = Company.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice] = 'Company was successfully updated.'
        format.html { redirect_to action: "index" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def companies_fb
    @empmaestcc = Empmaestcc.find(:all, :select =>['iemp', 'ncc'], :conditions => ['inivel = ?', 0])
    @c = 0; @ca = 0
    @companies = []
    @companies_fb = {}
    
    @empmaestcc.each do |cfb|
      if Company.where('code = ?', cfb.iemp).empty?
        @new_company = Company.new( :code => cfb.iemp,
                                    :name => "#{cfb.ncc}" )

        if @new_company.save
          @companies << @new_company
          @c += 1
        else
          @new_company.errors.each do |error|
            Rails.logger.error "Error Creating Company: #{cfb.ncc}, Description: #{error}"
          end
        end
      else
        # UPDATE
        @update_company = Company.find_by_code(cfb.iemp)
        params[:company] = { :name => "#{cfb.ncc}" }

        if @update_company.update_attributes(params[:company])
          @ca += 1
        end
      end
    end

    @companies_fb[:companies] = @companies
    @companies_fb[:notice] = ["#{t('helpers.titles.tasksfb')}: #{@c} #{t('helpers.titles.tasksfb_update')}: #{@ca}"]

    respond_to do |format|
      format.json { render json: @companies_fb }
    end
  end

end
