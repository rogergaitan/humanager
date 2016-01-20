var pl = {};

$(document).ready(function() {

  pl.PayrollHistories = function() {
    this.employees = Array();
  };

  pl.Employee = function () {
    this.id = null;
    this.name = null;
    this.total = 0;
    this.data = Array();
    this.add = Array();
  };

  pl.DataStructure = function() {
    this.identification = null;
    this.type_payment = null;
    this.type_payment_factor = null;
    this.date = null;
    this.time_worked = null;
    this.performance = null;
    this.subtotal = null;
    this.cc = Object();
    this.task = Object();
    this.old = false;
  };

});