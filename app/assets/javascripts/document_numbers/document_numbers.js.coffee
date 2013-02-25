DocumentNumber = {
	auto_increment: "auto_increment" #ENUM
}

$(document).ready ->
	$("#document_number_number_type").on "change", ()->
		if $("#document_number_number_type").val() is DocumentNumber.auto_increment
			$("#document_number_start_number").enableClientSideValidations()
		else
			$("#document_number_start_number").disableClientSideValidations()
			$("#document_number_start_number").next("label.message").remove()