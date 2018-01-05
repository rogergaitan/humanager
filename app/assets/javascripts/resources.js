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
	resources.showMessage = function(type, message, options) {

	  var json = [
			{
				'type':'success',
				'icon':'check',
				'title':'Étixo'
			},
			{
				'type':'danger',
				'icon':'times',
				'title':'Peligro'
			},
			{
				'type':'warning',
				'icon':'warning',
				'title':'Advertencia'
			},
			{
				'type':'info',
				'icon':'info-circle',
				'title':'Información'
			}
		];
		var that = $('#div-message');
		var i_icon = '';

		if (typeof options === "undefined" || options === null) {
	  	var options = {
	  		'dissipate': true
	  	}
	  }
  	
  	if(options.hasOwnProperty('icon')) {
  		i_icon = '<i id="custom-icon" class="'+options.icon+'"></i>';
		}

		$.each(json, function(idx, obj) {
			if(obj.type == type) {
			  $(that).addClass('alert-'+obj.type);
			  $(that).find('i').addClass('fa-'+obj.icon);
	  		$(that).find('h3 label').text(obj.title);
			} else {
				$(that).removeClass('alert-'+obj.type);
			  $(that).find('i').removeClass('fa-'+obj.icon);
			}
		});

	  $(that).find('#message').html(i_icon+message);
	  $(that).show();

	  if(options.dissipate) {
	    setTimeout(function() {
	      $(that).fadeOut("slow");
	      $(that).hide();
	    },4000);
	  }
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

	resources.updateValidation = function(model_name, reference_id) {
		
		$.ajax('/session_validation/update_time', {
	    type: 'POST',
	    data: {
	    	model_name: model_name,
	    	reference_id: reference_id
	    },
	    success: function(result) {
	    },
	    error: function(result) {
	    	setTimeout(function() {
          resources.PNotify('Tiempo vencido', 'Resfrescando...','info');
          location.reload();
        },2000);
	    }
	  });
	}
	
  resources.alphaNumericMask = function(selector) {
    $(selector).mask('A' + 'B'.repeat(30), {
      translation: {
        'A': { pattern: /[a-zA-Z]/ },
        'B': { pattern: /[a-zA-Z0-9 ]/ }
      }
    })
	}

	resources.checkCompany = function() {
		if($('#user_company_id option:selected').val() == "" ) {
      event.preventDefault();
      var message = 'Seleccione una Compañia';
      resources.PNotify('Compañia', message, 'warning');
    }
	}
	
	/**
	 * Custom Validations Using Parsley
	 */

	// Validate Special Characters
	window.Parsley.addValidator('noSpecialCharacters', {
		requirementType: 'regexp',
		validateString: function(value, requirement) {
			return requirement.test(value);
		},
		messages: {
			es: 'Valor inválido, no se permiten caracteres especiales.'
		}
	});


});
