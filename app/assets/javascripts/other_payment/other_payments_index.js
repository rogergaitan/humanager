$(".pagination a[href]").attr("data-remote", true);

$("#clean_button").on("click", function () {
  cleanSearch();
})

$("#other_payment_type, #calculation_type, #state").on("change", search);

function search () {
  $.ajax({
    url: "other_payments/search",
    dataType: "script",
    data: {
      other_payment_type: $("#other_payment_type").val(),
      calculation_type: $("#calculation_type").val(),
      state: $("#state").val()
    }
  });
}

function cleanSearch() {
  $("#other_payment_type, #calculation_type, #state").val("");
  
  $.ajax({
    url: "other_payments/",
    dataType: "script"
  });
}

