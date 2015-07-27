@application.directive "fileDropZone", ->
  scope:
    onDropFiles: "&"
  link: (scope, el, attrs) ->
    processDragOverOrEnter = (e) ->
      e.stopPropagation()
      e.preventDefault()

    processDrop = (e) ->
      e.stopPropagation()
      e.preventDefault()
      scope.onDropFiles files: e.originalEvent.dataTransfer.files

    el.bind "dragover", processDragOverOrEnter
    el.bind "dragenter", processDragOverOrEnter
    el.bind "drop", processDrop
