load_purchase_orders = function(e) {
	//needed to in-start function for this if
	if($('a#user_logged').length > 0) {
		$('.flap_search form#normal-search').css({'top' : '50px', 'right' : '10px', 'z-index' : '0'});
		$('.flap_search form#advance-search').css({'top' : '50px', 'right' : '10px', 'z-index' : '0'});
	}

	if($('#purchase_orders').length > 0) {
		e.preventDefault();
		if(!$('#purchase_orders').is(':empty')) {
			$.ajax({
				url: '/purchase_orders',
				dataType: 'script',
			});
		}
	}
};

load_purchases = function(e) {
	e.preventDefault();
	if(!$('#purchases').is(':empty')) {
		$.ajax({
			url: '/purchases',
			dataType: 'script',
		});
	}
};

load_quotations = function(e) {
	e.preventDefault();
	if(!$('#quotations').is(':empty')) {
		$.ajax({
			url: '/quotations',
			dataType: 'script',
		});
	}
};

show_hide_advance_search = function() {
	if($('.flap_search form#normal-search').is(':visible')) {
		$('div.navbar-search a#desplegar').text('Menos');
	}
	else {
		$('div.navbar-search a#desplegar').text('Más');
	}
	$('.flap_search form#normal-search').slideToggle('fast');
	$('.flap_search form#advance-search').slideToggle('fast');
};

submit_normal_search = function() {
	if($('.flap_search form#normal-search #search').val().length == 0) {
		return false;
	}
	else {
		return true;
	}
};

submit_advance_search = function(e) {
	if(($('.flap_search form#advance-search #code').val().length == 0) &&
		 ($('.flap_search form#advance-search #name').val().length == 0) &&
		 ($('.flap_search form#advance-search #applications').val().length == 0) &&
		 ($('.flap_search form#advance-search #part_number').val().length == 0)) {
		return false;
	}
	else {
		if(e.which == 13) {
			$('.flap_search form#advance-search').submit();
		}
	}
};

logged_user = function() {

}

$(document).ready(function() {
	
	$(document).on('ready', load_purchase_orders);

	$('ul.nav').on('click', '#load_purchase_orders', load_purchase_orders);	

	$('ul.nav').on('click', '#load_purchases', load_purchases);

	$('ul.nav').on('click', '#load_quotations', load_quotations);

	$('.flap_search form#normal-search').on('submit', submit_normal_search);

	$('.flap_search form#advance-search').on('keyup',submit_advance_search);

	$('div.navbar-search').on('click', 'a#desplegar', show_hide_advance_search);
});