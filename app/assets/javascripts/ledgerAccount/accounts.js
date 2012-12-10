$(document).ready(function() {
    $('#account-fb').on("click", function() {
    $('#account-fb').attr("disabled", true); //desabilito el boton
    var cc_array = [];
    $.getJSON('ledger_accounts/accountfb', function(element) {
      $(element.notice).each(function() { $('section.nav').append('<div class="notice">'+ this +'</div>').delay(5000).fadeOut(); });
      $(element.account).each(function() { 
        cc_array.push(new Array(this.iaccount ? this.iaccount : 0, this.naccount, this.ifather ? this.ifather : 0, this.id));
      });
      treeviewhr.cc_tree(cc_array);
       $('#account-fb').hide();
    })
  });

    treeviewhr.cc_tree(cuenta_contable);
    $('.expand_tree').on('click', treeviewhr.expand);
    $('a[rel=tooltip]').tooltip();
    $('.tree-hover').on({
      mouseenter: function() {
      $(this).children('.tree-actions').show();
    },
    mouseleave: function() {
      $('.tree-actions').hide();
    }})    
});

  function replace_value(value) {
    if (value == null) value = "";
    return value;
  }