var company = {}

$(document).ready(function() {

  $('#companies-fb').on('click', function() {
    $('section.nav').append('<div class="notice">Sincronización en Proceso</div>');
    $.getJSON( $('#companies_fb_companies_path').val(), function(element) {
      $(element.notice).each(function() { $('section.nav').append('<div class="notice">'+ this +'</div>').delay(5000).fadeOut(function(){location.reload();}); });
      $('#companies-fb').hide();
    })
  });

});
