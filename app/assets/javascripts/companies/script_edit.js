var company_edit = {}

$(document).ready(function() {

	var input_1 = $('#company_label_reports_1'), display_1 = $('#char-count-1'), count_1 = 0, limit = 30;
	var input_2 = $('#company_label_reports_2'), display_2 = $('#char-count-2'), count_2 = 0;
	var input_3 = $('#company_label_reports_3'), display_3 = $('#char-count-3'), count_3 = 0;

	count_1 = input_1.val().length, count_2 = input_2.val().length, count_3 = input_3.val().length;
	remaining_1 = limit - count_1, remaining_2 = limit - count_2, remaining_3 = limit - count_3;

	company_edit.update(remaining_1, display_1); 
	company_edit.update(remaining_2, display_2); 
	company_edit.update(remaining_3, display_3);

	input_1.keyup(function(e) {
	count_1 = $(this).val().length;
	remaining_1 = limit - count_1;

	company_edit.update(remaining_1, display_1);
	});

	input_2.keyup(function(e) {
	count_2 = $(this).val().length;
	remaining_2 = limit - count_2;

	company_edit.update(remaining_2, display_2);
	});

	input_3.keyup(function(e) {
	count_3 = $(this).val().length;
	remaining_3 = limit - count_3;

	company_edit.update(remaining_3, display_3);
	});

});

company_edit.update = function(count, display) {
	var txt = ( Math.abs(count) === 1 ) ? count + ' Carácteres restantes' :  count + ' Carácteres restantes'
	display.html(txt);
}
