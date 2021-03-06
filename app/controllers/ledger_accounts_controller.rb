class LedgerAccountsController < ApplicationController
  load_and_authorize_resource
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

  def accountfb
    cntpuc = Cntpuc.where("bvisible = ?", 'T').find(:all, :select => ['icuenta', 'ncuenta', 'ipadre'])

    c = 0; ca = 0
    @accounts_fb = {}

    cntpuc.each do |account|
      if LedgerAccount.where("iaccount = ?", account.icuenta).empty?
        new_account = LedgerAccount.new(:iaccount => account.icuenta, :naccount => firebird_encoding(account.ncuenta),
          :ifather => account.ipadre)
        if new_account.save
          c += 1
        else
          @new_task.er.each do |error|
            Rails.logger.error "Error Creating account: #{account.icuenta}, 
                              Description: #{error}"
          end
        end
      else
        # UPDATE
        update_cntpuc = LedgerAccount.find_by_iaccount(account.icuenta)
        params[:ledgerAccount] = { :naccount => firebird_encoding(account.ncuenta), :ifather => account.ipadre }
        if update_cntpuc.update_attributes(params[:ledgerAccount])
          ca += 1
        end
      end 
      @accounts_fb[:notice] = ["#{t('helpers.titles.tasksfb').capitalize}: #{c} #{t('helpers.titles.tasksfb_update')}: #{ca}"]
    end 

    respond_to do |format|
      format.json {render json: @accounts_fb}
    end
  end 

  # Busca todas las cuentas contables pero solamente selecciona el id y ncuenta
  # Este metodo se utilza para crear o editar otros salarios
  def fetch
    @names_ids = LedgerAccount.children_debit_accounts
    respond_with(@names_ids)
  end
  
  def credit_accounts
    @credit_accounts = LedgerAccount.children_credit_accounts
    respond_with(@credit_accounts)
  end

  def get_parent_info
    @cc_child ||= LedgerAccount.find(:all, :select =>['iaccount', 'ifather', 'naccount'])
  end

  def get_bank_account
    respond_with LedgerAccount.bank_account
  end

end
