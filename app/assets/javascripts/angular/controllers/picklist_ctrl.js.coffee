app.controller('PicklistCtrl', ['$scope', '$resource', ($scope, $resource) ->
  picklist = $resource('/deliveries/picklist.json')
  $scope.picklist = picklist.query()
  $scope.gridOptions = {data: 'picklist'}
])