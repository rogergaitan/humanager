cantons = []
districts = []

addField = (el,ent)->
	time = new Date().getTime()
	regexp = new RegExp($(el).data('id'), 'g')
	$("#bank_accounts").append($(el).data('fields').replace(regexp, time)) if ent == "bank_account"
	$("#contacts").append($(el).data('fields').replace(regexp, time)) if ent == "contact"
	$("#telephones").append($(el).data('fields').replace(regexp, time)) if ent == "telephone"

removeField = (el, ent) ->
	$(el).prev('input[type=hidden]').val(1)
	$(el).closest('.bank_account').hide() if ent == "bank_account"
	$(el).closest('.contact').hide() if ent == "contact"
	$(el).closest('.telephone').hide() if ent == "telephone"

getCantons = ()->
	$.getJSON "/cantons.json", (data) ->
  $.each data, (key, val) ->
  	cantons.push new Array(val.province_id, val.name, val.id)

getDistricts = ()->
	$.getJSON "/districts.json", (data) ->
  $.each data, (key, val) ->
  	districts.push new Array(val.canton_id, val.name, val.id)
      
cantonSelected = () ->
  canton_id = $('.cantons').val()
  $('.districts').find('option').remove()
  $(districts).each ->
    $('.districts').append("<option value='#{this[2]}'>#{this[1]}</option>") if this[0].toString() is canton_id 

provinceSelected = () ->
  province_id = $('.provinces').val()
  $('.cantons').find('option').remove()
  $('.districts').find('option').remove()
  $(cantons).each ->
  	$('.cantons').append("<option value='#{this[2]}'>#{this[1]}</option>") if this[0].toString() is province_id

$(document).ready ->
	form = $("form").attr("id")
	$("ul.vendor_tabs").on "click", "a", (e) ->
		if !($('form[data-validate]').isValid(ClientSideValidations.forms[form].validators))
    	e.preventDefault()
    	return false
	$('form').on 'click', '.add_bank_account', (e) ->
		e.preventDefault()
		addField(@, "bank_account")
	$('form').on 'click', '.remove_bank_account', (e) ->
		e.preventDefault()
		removeField(@, "bank_account")
	$('form').on 'click', '.add_contact', (e) ->
		e.preventDefault()
		addField(@, "contact")
	$('form').on 'click', '.remove_contact', (e) -> 
		e.preventDefault()
		removeField(@, "contact")
	$('form').on 'click', '.add_telephone', (e) ->
		e.preventDefault()
		addField(@, "telephone")
	$('form').on 'click', '.remove_telephone', (e) -> 
		e.preventDefault()
		removeField(@, "telephone")
	$('.provinces').change -> provinceSelected()
	$('.cantons').change -> cantonSelected()
	getCantons()
	getDistricts()
	
	if form is "new_vendor"
		console.log form
		provinceSelected()
		cantonSelected()
		return false
	