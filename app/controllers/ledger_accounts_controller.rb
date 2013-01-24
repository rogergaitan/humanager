class LedgerAccountsController < ApplicationController
  respond_to :html, :json
  before_filter :get_ledger, :only => [:edit, :update, :destroy]
  before_filter :get_parent_info, :only => [:new, :edit]

  def get_ledger
    @ledger_account = LedgerAccount.find(params[:id])
  end

  def index
    @ledger_accounts = LedgerAccount.all
    respond_with(@ledger_accounts)
  end

  # GET /ledger_accounts/1
  # GET /ledger_accounts/1.json
  def show
    @ledger_account = LedgerAccount.find(params[:id])
    respond_with(@ledger_account)
  end

  # GET /ledger_accounts/new
  # GET /ledger_accounts/new.json
  def new
    @ledger_account = LedgerAccount.new
    respond_with(@ledger_account)
  end

  # GET /ledger_accounts/1/edit
  def edit
  end

  # POST /ledger_accounts
  # POST /ledger_accounts.json
  def create
    @ledger_account = LedgerAccount.new(params[:ledger_account])

    respond_to do |format|
      if @ledger_account.save
        format.html { redirect_to @ledger_account, notice: 'Ledger account was successfully created.' }
        format.json { render json: @ledger_account, status: :created, location: @ledger_account }
      else
        format.html { render action: "new" }
        format.json { render json: @ledger_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ledger_accounts/1
  # PUT /ledger_accounts/1.json
  def update

    respond_to do |format|
      if @ledger_account.update_attributes(params[:ledger_account])
        format.html { redirect_to @ledger_account, notice: 'Ledger account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ledger_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ledger_accounts/1
  # DELETE /ledger_accounts/1.json
  def destroy
    @ledger_account.destroy

    respond_to do |format|
      format.html { redirect_to ledger_accounts_url }
      format.json { head :no_content }
    end
  end

  def accountfb
      @cntpuc = Cntpuc.where("bvisible = ?", 'T').find(:all, :select => ['icuenta', 'ncuenta', 'ipadre'])

      @c = 0
      @accounts = []
      @accounts_fb = {}

      @cntpuc.each do |account|
        if LedgerAccount.where("iaccount = ?", account.icuenta).empty?
          @new_account = LedgerAccount.new(:iaccount => account.icuenta, :naccount => firebird_encoding(account.ncuenta),
            :ifather => account.ipadre)
          if @new_account.save
            @accounts << @new_account
            @c += 1
          else
            @new_task.er.each do |error|
              Rails.logger.error "Error Creating account: #{account.icuenta}, 
                                Description: #{error}"
            end
          end
        end 
        @accounts_fb[:account] = @accounts
        @accounts_fb[:notice] = "#{t('helpers.titles.tasksfb').capitalize}: #{@c}"
      end 

      respond_to do |format|
        format.json {render json: @accounts_fb}
      end
  end 

#Busca todas las cuentas contables pero solamente selecciona el id y ncuenta 
#Este metodo se utilza para crear o editar otros salarios
  def fetch
    @names_ids = LedgerAccount.find(:all, :select =>['id','naccount'])
    respond_with(@names_ids)
  end

  def get_parent_info
    @cc_child ||= LedgerAccount.find(:all, :select =>['iaccount','ifather', 'naccount'])
  end

end
