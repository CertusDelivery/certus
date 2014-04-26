app.directive('focusMe', ['$timeout', '$parse', ($timeout, $parse) ->
  link: (scope, element, attrs) ->
    model = $parse(attrs.focusMe)
    scope.$watch(model, (value) ->
      if value == true
        $timeout( ->
          element[0].focus()
        )
    )
    element.bind('blur', ->
      scope.$watch(model, (value) ->
        if value == true
          $timeout( ->
            element[0].focus()
          )
        else
          element[0].blur()
      )
      #scope.$apply(model.assign(scope, false))
      #scope.$apply(model.assign(scope, true))
    )
])


app.directive('pressEnter', ->
  (scope, element, attrs) ->
    element.bind('keypress', (event)->
      if event.which == 13
        scope.$apply(->
          scope.$eval(attrs.pressEnter)
        )
        element.val('')
        event.preventDefault()
    )
)

app.directive('clickToEdit', ->
    editorTemplate = '<div class="click-to-edit">' +
        '<div ng-hide="view.editorEnabled" ng-click="enableEditor()">' +
            '{{value}}&nbsp;&nbsp;&nbsp;' +
        '</div>' +
        '<div ng-show="view.editorEnabled">' +
            '<input ng-model="view.editableValue" ng-blur="save()" />' +
        '</div>' +
    '</div>'
    {
        restrict: "E",
        replace: true,
        template: editorTemplate,
        scope: {
            value: "=data",
        },
        link: ($scope, $element, $attrs)->
            $scope.view = {
                editableValue: $scope.value,
                editorEnabled: false
            }
            $scope.enableEditor = ->
                $scope.view.editorEnabled = true
                $scope.view.editableValue = $scope.value

            $scope.disableEditor = ->
                $scope.view.editorEnabled = false

            $scope.save = ->
                $scope.value = $scope.view.editableValue
                $scope.disableEditor()
                $scope.$parent.$eval($attrs.afterSave)
    }
)

app.directive('clickToSelect', ['$parse', ($parse) ->
    selectorTemplate = '<div class="click-to-select">' +
        '<div ng-hide="view.selectorEnabled" ng-click="enableSelector()">' +
            '{{displayValue}}&nbsp;&nbsp;&nbsp;' +
        '</div>' +
        '<div ng-show="view.selectorEnabled">' +
            '<select ng-blur="save()" ng-model="view.selectableValue" ng-options="key for (key, val) in view.options"></select>' +
        '</div>' +
    '</div>'
    {
        restrict: "E",
        replace: true,
        template: selectorTemplate,
        scope: {
            value: "=data",
        },
        link: ($scope, $element, $attrs)->
            $scope.view = {
                selectableValue: $scope.value,
                options:         angular.fromJson($attrs.options)
                selectorEnabled: false
            }

            $scope.runDisplayValue = ->
              $scope.displayValue = if typeof($scope.value)=="boolean" then (if $scope.value then "YES" else "NO") else $scope.value
            $scope.runDisplayValue()

            $scope.enableSelector = ->
                $scope.view.selectorEnabled = true
                $scope.view.selectableValue = $scope.value

            $scope.disableSelector = ->
                $scope.view.selectorEnabled = false

            $scope.save = ->
                $scope.value = $scope.view.selectableValue
                $scope.runDisplayValue()
                $scope.disableSelector()
                $scope.$parent.$eval($attrs.afterSave)
    }
])
