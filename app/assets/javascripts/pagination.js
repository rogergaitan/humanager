$.fn.pagination =function(show_per_page){
	//object element
	var element = $(this[0]);
	//object ID
	var element_id = element.attr('id');
	//getting the amount of elements inside content div
	var number_of_items = element.find('.pagination').children().size();
	//calculate the number of pages we are going to have
	var number_of_pages = Math.ceil(number_of_items/show_per_page);

	//set the value of our hidden input fields
	$('#'+element_id+' .current_page').val(0);
	$('#'+element_id+' .show_per_page').val(show_per_page);

	//now when we got all we need for the navigation let's make it '

	/*
	what are we going to have in the navigation?
		- link to previous page
		- links to specific pages
		- link to next page
	*/


	var navigation_html = '<a class="previous_link" href="javascript:previous('+element_id+');"><div class="icon-backward"></div></a>';
	var current_link = 0;
	while(number_of_pages > current_link){
		navigation_html += '<a class="page_link" href="javascript:go_to_page(' + current_link +','+element_id+')" longdesc="' + current_link +'">'+ (current_link + 1) +'</a>';
		current_link++;
	}
	navigation_html += '<a class="next_link" href="javascript:next('+element_id+');"><div class="icon-forward"></div></a>';
	if (number_of_pages > 0) {
		$('#'+element_id+' .page_navigation').html(navigation_html);
	};
	

	//add active_page class to the first page link
	$('#'+element_id+' .page_navigation .page_link:first').addClass('active_page');

	//hide all the elements inside content div
	$('#'+element_id+' .pagination').children().css('display', 'none');

	//and show the first n (show_per_page) elements
	$('#'+element_id+' .pagination').children().slice(0, show_per_page).css('display', 'block');

};

function previous(element_id){

	new_page = parseInt($('#'+element_id.id+' .current_page').val()) - 1;
	//if there is an item before the current active link run the function
	if($('#'+element_id.id+ ' .active_page').prev('.page_link').length==true){
		go_to_page(new_page,element_id);
	}

}

function next(element_id){
	new_page = parseInt($('#'+element_id.id+ ' .current_page').val()) + 1;
	//if there is an item after the current active link run the function
	if($('#'+element_id.id+ ' .active_page').next('.page_link').length==true){
		go_to_page(new_page,element_id);
	}

}
function go_to_page(page_num,element_id){
	//get the number of items shown per page
	var show_per_page = parseInt($('#'+element_id.id+' .show_per_page').val());

	//get the element number where to start the slice from
	start_from = page_num * show_per_page;

	//get the element number where to end the slice
	end_on = start_from + show_per_page;

	//hide all children elements of content div, get specific items and show them
	$('#'+element_id.id+' .pagination').children().css('display', 'none').slice(start_from, end_on).fadeIn("slow").css('display', 'block').fadeIn("slow");

	/*get the page link that has longdesc attribute of the current page and add active_page class to it
	and remove that class from previously active page link*/
	$('#'+element_id.id+' .page_link[longdesc=' + page_num +']').addClass('active_page').siblings('.active_page').removeClass('active_page');

	//update the current page input field
	$('#'+element_id.id+' .current_page').val(page_num);
}