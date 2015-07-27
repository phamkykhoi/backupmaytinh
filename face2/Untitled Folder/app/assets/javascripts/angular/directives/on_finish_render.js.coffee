@application.directive "onFinishRender", ["$timeout", ($timeout) ->
  link: (scope, element, attr) ->
    if scope.$last == true
      $timeout ->
        scope.$emit "ngRepeatFinished"
]
