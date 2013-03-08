Accounts =
  search_length: 3
  update: 'edit'
  create: 'new'

Accounts.save_account = (action, row) ->
  values = $(row).find('input').data()
  $("#new_account label.message").remove()
  $("#new_account input[type='text']").val("")
  $("#new_account .modal-body input[type='hidden']").val("")
  $("form #form_edit").html("")
  $("form#account_form").attr("action", "/ledger_accounts");
  $("#new_account .modal-body input[type='checkbox']").prop('checked', false)
  $("#ledger_account_account_type").val("")
  $("#ledger_account_ifather").val(values.iaccount)

  if action is Accounts.update
    $("form #form_edit").html("<input type='hidden' value='put' name='_method'>")
    $("form#account_form").attr("action", "/ledger_accounts/#{values.id}");
    $("#ledger_account_account_type").val(values.accountType)
    $("#ledger_account_iaccount").val(values.iaccount)
    $("#ledger_account_naccount").val(values.naccount)
    $("#ledger_account_cost_center").prop('checked', true) if values.costCenter
    $("#ledger_account_foreign_currency").prop('checked', true) if values.foreignCurrecy
    $("#ledger_account_request_entity").prop('checked', true) if values.requestEntity

Accounts.ajax = (form) ->
  $.ajax
    type: "POST",
    url: $(form).attr("action")
    data: $(form).serialize()
    dataType: "script"
    complete: (data) ->
      $("button.cancel_submit").trigger("click")

$(document).ready ->
  main = $("table.table_accounts")
  $("#new_account").on 'shown', ->
    $("form").resetClientSideValidations()
    $("form").enableClientSideValidations()
  
  main.on 'click', '.create_account', ->
    Accounts.save_account(Accounts.create, $(this).closest('tr'))
    $("#new_account").modal()
    
  main.on 'click', '.update_account', ->
    Accounts.save_account(Accounts.update, $(this).closest('tr'))
    $("#new_account").modal()
  $("form#account_form").submit (e) ->
    e.preventDefault()
    Accounts.ajax(this)