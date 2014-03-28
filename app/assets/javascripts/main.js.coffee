@app = angular.module('certus', ['ngResource', 'ui.bootstrap', 'ngGrid'])

$(document).on "click", "#print_picking_list", (e) ->
  window.open($("#print_picking_list").attr("url"), 'printWindow','height=600,width=609,toolbar=no,menubar=no,scrollbars=yes, resizable=no,location=no, status=no') ;
