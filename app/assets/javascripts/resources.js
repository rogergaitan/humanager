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
});
