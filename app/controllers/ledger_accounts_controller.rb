class LedgerAccountsController < ApplicationController

  before_filter :title
  respond_to :html, :json, :js

  def index
    @ledger_account = LedgerAccount.new
    respond_with @accounts = LedgerAccount.order(:iaccount)
  end

  def show
    @ledger_account = LedgerAccount.find(params[:id])
    respond_with(@ledger_account)
  end

  def new
    @ledger_account = LedgerAccount.new
    respond_with(@ledger_account)
  end

  def edit
    @ledger_account = LedgerAccount.find(params[:id])
  end

  def create
    @ledger_account = LedgerAccount.new(params[:ledger_account])
    flash[:notice] =  t('.activerecord.models.ledger_account').capitalize +
      " #{@ledger_account.iaccount} " + t('.notice.a_successfully_created') if @ledger_account.save
    respond_with(@ledger_account, :location => ledger_accounts_url)
  end

  def update
    @ledger_account = LedgerAccount.find(params[:id])
    flash[:notice] =  t('.activerecord.models.ledger_account').capitalize +
      " #{@ledger_account.iaccount} " + t('.notice.a_successfully_updated') if @ledger_account.update_attributes(params[:ledger_account])
    respond_with(@ledger_account, :location => ledger_accounts_url)
  end

  def destroy
    @ledger_account = LedgerAccount.find(params[:id])
    @ledger_account.destroy
    flash[:notice] = t('.activerecord.models.ledger_account').capitalize + 
      " #{@ledger_account.iaccount} " + t('.notice.a_successfully_deleted')
    respond_with(@ledger_account, :location => ledger_accounts_url)
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

  def fetch
    @names_ids = LedgerAccount.find(:all, :select =>['id','naccount'])
    respond_with(@names_ids)
  end

  def get_ledger
    @ledger_account = LedgerAccount.find(params[:id])
  end

  def title
    @title = "#{t('.activerecord.models.ledger_account').capitalize} " + t(".helpers.links.#{action_name}" )
  end

end
