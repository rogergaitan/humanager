numberPhoneFields = 1
province_id = $('#customer_entity_attributes_addresses_attributes_0_province_id').val()
canton_id = $('#customer_entity_attributes_addresses_attributes_0_canton_id').val()

provinceSelected = () ->
  $('#customer_entity_attributes_addresses_attributes_0_district_id').find('option').remove()
		$('#customer_entity_attributes_addresses_attributes_0_canton_id').find('option').remove()
  $(cantons).each ->
  		$('#customer_entity_attributes_addresses_attributes_0_canton_id').append ->
    		"<option value=#{@[2]}>#{@[1]}</option>" if @[0] == province_id

cantonSelected = () ->  
  $('#customer_entity_attributes_addresses_attributes_0_district_id').find('option').remove()
  $(district).each ->
    $('#customer_entity_attributes_addresses_attributes_0_district_id').append ->
    	"<option value= #{@[2]}>#{@[1]}</option>" if @[0] is canton_id

addFields = (e) ->
	if numberPhoneFields < 3 
		time = new Date().getTime()
		regexp = new RegExp($(this).data('id'), 'g')
		$(@).before($(this).data('fields').replace(regexp, time))
		numberPhoneFields += 1
	if numberPhoneFields == 3
		$('a.add_fields').hide()
	e.preventDefault()

removeFields = (e) ->
	if numberPhoneFields > 1 
		$(this).prev('input[type=hidden]').val(1)
		$(this).closest('.employee_contact_fields').hide()
		numberPhoneFields -= 1
	if numberPhoneFields < 3
		$('a.add_fields').show()
	e.preventDefault()
  
$ ->
	$('#customer_department_id').change -> 
  	departmentSelected
	$('#customer_entity_attributes_addresses_attributes_0_province_id').change ->
		provinceSelected
	$('#customer_entity_attributes_addresses_attributes_0_canton_id').change -> 
		cantonSelected
	$('form').on('click', '.add_fields', addFields)
	$('form').on('click', '.remove_fields', removeFields)
	provinceSelected()
	cantonSelected()
	$('a.remove_fields').remove()
  