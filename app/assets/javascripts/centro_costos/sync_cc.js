$(document).ready(function() {
  $('#sync-cc').click(function() {
    $.getJSON('/centro_de_costos/sync_cc', function(element) {
      $(element.notice).each(function() { $('section.nav').append('<div class="notice">'+ this +'</div>').delay(5000).fadeOut(); });
      $(element.centrocostos).each(function() { add_cc(this, 'table#cc-data')});
      $('#sync-cc').hide();
    })
  });
	treeviewhr.cc_tree(centro_costos);
	$('.expand_tree').click(treeviewhr.expand);
})

function add_cc(centro_costos, target_table)
{
  var row = $(target_table + '> tbody:last').append('<tr>' + 
      '<td>' + replace_value(centro_costos.iempresa) + '</td>' +
      '<td>' + replace_value(centro_costos.icentro_costo) + '</td>' +
      '<td>' + replace_value(centro_costos.nombre_cc) + '</td>' +
      '<td>' + replace_value(centro_costos.icc_padre) + '</td>' +
      '<td><a href="/centro_de_costos/'+ centro_costos.id +'/edit" class="btn btn-mini">Editar</a> ' +
      '<a href="/centro_de_costos/'+ centro_costos.id +'" class="btn btn-mini btn-danger" ' +
      'data-confirm="¿Está seguro(a)?" data-method="delete" rel="nofollow">Eliminar</a></td>' +
    '</tr>');
  return row;
}

function replace_value(value)
{
  if (value == null) value = "";
  return value;
}