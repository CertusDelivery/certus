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
