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

	resources.prettyNumber = function(input) {

		// Only 2 decimals
		input = parseFloat(input).toFixed(2);

		// If the regex doesn't match, `replace` returns the string unmodified 
		return (input.toString()).replace( 
			// Each parentheses group (or 'capture') in this regex becomes an argument 
			// to the function; in this case, every argument after 'match' 
			/^([-+]?)(0?)(\d+)(.?)(\d+)$/g, function(match, sign, zeros, before, decimal, after) {
				
				// Less obtrusive than adding 'reverse' method on all strings
				var reverseString = function(string) { return string.split('').reverse().join(''); }; 
				
				// Insert commas every three characters from the right 
				var insertCommas = function(string) { 
					// Reverse, because it's easier to do things from the left 
					var reversed = reverseString(string); 
					
					// Add commas every three characters 
					var reversedWithCommas = reversed.match(/.{1,3}/g).join(','); 

					// Reverse again (back to normal) 
					return reverseString(reversedWithCommas);
				}; 

				// If there was no decimal, the last capture grabs the final digit, so 
				// we have to put it back together with the 'before' substring 
				return sign + (decimal ? insertCommas(before) + decimal + after : insertCommas(before + after));
			}
		);
	}

	// To use this, please include this view: render "/layouts/message"
	resources.showMessage = function(type, message) {
	  var icon;
	  if(type === "success") {
	    icon = 'check';
	  }
	  if(type === "danger") {
	    icon = 'times';
	  }
	  if(type === "warning") {
	    icon = 'warning';
	  }
	  if(type === "info") {
	    icon = 'info-circle';
	  }

	  $('#div-message').show();
	  $('#div-message').find('div.alert.alert-dismissable').addClass('alert-'+type);
	  $('#div-message').find('label#message').html(message);
	  $('#div-message').find('i').addClass('fa-'+icon);

	  $('div.alert.alert-'+type).fadeIn(4000, function() {
	    setTimeout(function() {
	        $(this).fadeOut("slow");
	        $('#div-message').find('div.alert.alert-dismissable').removeClass('alert-' + type);
	        $('#div-message').find('i').removeClass('fa-' + icon);
	        $('#div-message').hide();
	    },4000);
	  });
	}

	resources.PNotify = function(title, text, type) {
		new PNotify({
			title: title,
			text: text,
			type: type,
			styling: 'fontawesome'
		});
	}

	resources.parseBool = function(str) {
	  if(str==null) return false;
	  if(str=="false") return false;
	  if(str=="0") return false;
	  if(str=="true") return true;
	  if(str=="1") return true;

	  return false;
	}

});
