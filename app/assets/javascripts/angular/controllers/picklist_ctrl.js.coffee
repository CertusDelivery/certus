app.controller('PicklistCtrl', ['$scope', '$resource', ($scope, $resource) ->
  picklist = $resource('/deliveries/picklist.json')
  $scope.picklist = picklist.query()
  $scope.gridOptions = {
    data: 'picklist',
    columnDefs: [
      {field: 'picked_status', displayName: 'Picked Satus'},
      {field: 'product_name', displayName: 'Product Name'},
      {field: 'shipping_weight', displayName: 'Shipping Weight'},
      {field: 'location', displayName: 'Location'},
      {field: 'delivery_id', displayName: 'Order ID'},
      {field: 'picker_bin_number', displayName: 'Bin'},
      {field: 'store_sku', displayName: 'Store SKU'}
    ]
  }
])