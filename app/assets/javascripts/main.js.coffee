@app = angular.module('certus', ['ngResource', 'ui.bootstrap', 'ngGrid'])

$(document).on "click", ".print_button", (e) ->
  window.open($(this).attr("url"), 'printWindow','height=600,width=609,toolbar=no,menubar=no,scrollbars=yes, resizable=no,location=no, status=no') ;
