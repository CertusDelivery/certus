app.controller('PicklistCtrl', ['$scope', '$resource', '$http', ($scope, $resource, $http) ->
  picklist = $resource('/api/deliveries/picklist.json')
  $scope.picklist = picklist.query()
  $scope.location_sort = 'asc'
  $scope.mySelections = []
  cellEditableTemplate = "<input ng-class=\"'colt' + col.index\" ng-input=\"COL_FIELD\" ng-model=\"COL_FIELD\"  ng-blur=\"updateEntity(row.entity)\" />"
  cellTemplatePickedlocation = '<div ng-dblclick=\"removeFocus()\">{{row.getProperty(col.field)}}</div>'
  cellTemplatePicked = '<div ng-class="{hidden: row.getProperty(col.field) == \'PICKED\' ? false : true }" class="picked">✓</div>'

  $scope.gridOptions = {
    data: 'picklist',
    columnDefs: [
      {field: 'picking_progress', displayName: 'Qty', width: '10%'},
      {field: 'product_name', displayName: 'Product', width: '40%'},
      {field: 'shipping_weight', visible: false},
      {field: 'location', displayName: 'Location', sortable: false, cellTemplate: cellTemplatePickedlocation, enableCellEdit: true, editableCellTemplate: cellEditableTemplate, width: '15%'},
      {field: 'delivery_id', displayName: 'ID', width: '10%'},
      {field: 'picked_status', displayName: 'Picked', width: '10%', cellTemplate: cellTemplatePicked},
      {field: 'store_sku', displayName: 'SKU', width: '15%'},
      {field: 'id', visible: false}
    ],
    selectedItems: $scope.mySelections,
    multiSelect: false,
    enableHighlighting: true,
    sortInfo: { fields: ['product_name'], directions: ['asc']}
  }

  $scope.$on('ngGridEventData', ->
    found = false
    angular.forEach $scope.picklist, (row, index) ->
      return if found
      if row.picked_status == 'UNPICKED'
        $scope.gridOptions.selectRow(index, true)
        found = true
  )

  $scope.clearSortingData = ->
    if ($scope.gridOptions)
      $scope.gridOptions.ngGrid.config.sortInfo = { fields:[], directions: [] }
      angular.forEach($scope.gridOptions.ngGrid.lastSortedColumns, (c) ->
        c.sortPriority = null
        c.sortDirection = ""
      )
      $scope.gridOptions.ngGrid.lastSortedColumns = []

  $scope.refreshUnpickedCount = ->
    $http.get('/api/deliveries/unpicked_orders').success( (data) ->
      $scope.unpicked_count = data
    )

  $scope.loadNewOrder = ->
    $scope.notice = ''
    $scope.errorMessage = ''
    loader = $resource('/api/deliveries/load_unpicked_order.json')
    $scope.picklist = loader.query()
    $scope.refreshUnpickedCount()

  $scope.loadOrdersByLocation = ->
    $scope.clearSortingData()
    loader = $resource('/api/deliveries/sort_picking_orders.json', {direction: $scope.location_sort})
    if $scope.location_sort == 'asc'
      $scope.location_sort = 'desc'
    else
      $scope.location_sort = 'asc'
    $scope.picklist = loader.query()


  $scope.addFocus = ->
    $scope.focusScanner = true

  $scope.removeFocus = ->
    $scope.focusScanner = false

  $scope.timer = ->
    today = new Date()
    $scope.time = today.toTimeString()

  $scope.focusScanner = true
  $scope.refreshUnpickedCount()
  $scope.timer()
  setInterval(
    ->
      $('#current_time').click()
    1000
  )
  setInterval(
    ->
      $('#unpicked_order_count').click()
    5000
  )

  # operation_code: 1 -> normal, 2 -> out of stock
  $scope.pickProduct = (operation_code) ->
    $scope.notice = ''
    $scope.errorMessage = ''
    barcode = $scope.scannedBarcode
    deliveryItem = $scope.mySelections[0]
    if deliveryItem.picking_progress.split('/')[2] isnt '0' and deliveryItem.store_sku isnt barcode and deliveryItem.is_replaced is false
      $scope.substituteProduct(deliveryItem.id, deliveryItem.product_name, barcode)
      return
    barcode = "OUT_OF_STOCK" if operation_code == 2
    return false unless barcode
    $http.post('/api/delivery_items/pick.json',
       barcode: barcode,
       id: deliveryItem.id,
       delivery_id: deliveryItem.delivery_id,
       operation_code: operation_code
    ).success((data) ->
      $scope.scannedBarcode = ''
      $scope.notice = data.message if data.message
      if data.remove_completed_delivery
        $scope.picklist = picklist.query()
      else
        angular.forEach $scope.picklist, (row, index) ->
          if row.id == data.id
            angular.forEach data, (v, k) ->
              row[k] = v
            $scope.gridOptions.selectItem(index, true)
            $('.ngGrid').find('.selected').fadeTo('fast',0).fadeTo('fast',1)
            if data.picked_status is 'PICKED'
              $scope.gridOptions.selectItem(index+1, true)
    ).error((data) ->
      if data.status is 'nok'
        $scope.scannedBarcode = ''
        $scope.errorMessage = data.message
    )

  $scope.markAsOutOfStock = ->
    $scope.pickProduct(2)

  $scope.substituteProduct = (deliveryItemID, deliveryItemName, substituteBarcode) ->
    # product = $source('url/substituteBarcode').query()
    # mock here
    product = { product_name: "Alternative Product", client_sku: '1010101010101010', store_sku: '1010101010101010', price: 50.0,   tax: 4.0, other_adjustments: 0 }
    ensureMsg = 'Do you want to substitude ' + product.product_name + ' for ' + deliveryItemName + '?'
    if confirm ensureMsg
      $http.post('api/delivery_items/'+deliveryItemID+'/substitute.json',
        product: product
      ).success((data) ->
        # TODO
        alert(data.message)
      )


  $scope.removePickedOrders = ->
    $scope.notice = ''
    $scope.errorMessage = ''
    $http.delete('/api/deliveries/remove_picked_orders.json'
    ).success((data) ->
      $scope.notice = data.message if data.message
      $scope.picklist = picklist.query()
    )

  $scope.updateEntity = (row) ->
    if row.location is ''
      picklist = $resource('/api/deliveries/picklist.json')
      $scope.picklist = picklist.query()
    else
      $http.post('/api/delivery_items/'+row.id+'/update_location',
        location: row.location
      ).success((data) ->
        if data.status is false
          row.location = data.location
      )
    $scope.addFocus()
])
