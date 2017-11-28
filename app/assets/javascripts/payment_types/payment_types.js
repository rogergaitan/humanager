$('#payment_type_factor').mask("FN.NN", {
  translation: {
    'N': {pattern: /\d/, optional: true},
    "F": {pattern: /[1-9]/}
  }
});    
