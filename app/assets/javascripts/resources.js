// To show properly the error messages
window.ParsleyConfig = {
	successClass: 'has-success', 
	errorClass: 'has-error', 
	errorElem: '<span></span>', 
	errorsWrapper: '<span class="help-block"></span>', 
	errorTemplate: "<div></div>", 
	classHandler: function(el) {
		return el.$element.closest(".form-group");
	}
};

var resources = {};

$(document).ready(function() {

	// This function only allows numbers with 2 decimals
	// Use: .keyup(resources.twoDecimals)
	resources.twoDecimals = function() {

		var regexPattern = /^\d+(\.{0,1}\d{0,2})?$/; 

		if(!(/^\d+(\.{0,1}\d{0,2})?$/.test(this.value))) {
	        this.value = this.value.substring(0, this.value.length - 1);
      	}

      	if(regexPattern.test(this.value)) {
      		this.value.substring(0, this.value.length - 1);
      	}
	}

	// Custom Checkboxes 
	$('.icheck input').iCheck({
		checkboxClass: 'icheckbox_minimal-blue',
		radioClass: 'iradio_minimal-blue'
	});

});
