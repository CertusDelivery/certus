@app = angular.module('certus', ['ngResource', 'ui.bootstrap', 'ngGrid'])

windowResize = ->
  scope = angular.element($('#picklist')[0]).scope()
  scope.$apply( ->
    if window.innerWidth > 768
      scope.gridOptions.$gridScope.columns[4].visible = true
    else
      scope.gridOptions.$gridScope.columns[4].visible = false
  )

$(document).ready ->
  if $(".deliveries_picklist").length > 0
    windowResize()
    window.onresize = windowResize