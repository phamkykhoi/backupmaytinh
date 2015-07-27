@application.controller "photoFormCtrl", ["$scope", "temporallyPhoto",
  ($scope, temporallyPhoto) ->
    $scope.init = (photos) ->
      $scope.photos = []
      if photos.length == 0
        $scope.photos.push {url: undefined, description: ""}
      else
        for photo in photos
          $scope.photos.push {url: photo.temporally_photo_url, description: photo.description}
        unless $scope.photos[0].url == undefined
          $scope.photos.push {url: undefined, description: ""}

    $scope.$on "ngRepeatFinished", (ngRepeatFinishedEvent) ->
      $(".upload_image").each (index) ->
        if ($(@).css("background-image") == "none") && $scope.photos[index].url
          $(@).css
            "background-image": "url(#{$scope.photos[index].url})"
            display: "block"

      $(".upload_file").change ->
        $submitButton =  $(".submitting-post")
        $submitButton.attr "disabled", true

        file = $(@).prop("files")[0]

        reader = new FileReader
        reader.onload = (e) =>
          thumnail = e.target.result
          $(@).parent().prev()
            .css "background-image": "url(#{thumnail})"

        reader.readAsDataURL file

        formData = new FormData
        formData.append "file", file
        temporallyPhoto.save formData,
          (response) =>
            $(@).parent().prev().show()

            url = response["temporally_photo_url"]
            $(@).prev().val url

            $submitButton.removeAttr "disabled"
            $scope.add()
          , ->
            $submitButton.removeAttr "disabled"

    $scope.add = ->
      if $scope.photos.length < 5
        $scope.photos.push {url: undefined, description: ""}

    $scope.remove = (index) ->
      $scope.photos.splice index, 1

    $scope.addNewFiles = (newFiles, index) ->
      $submitButton =  $(".submitting-post")
      $submitButton.attr "disabled", true

      file = newFiles[0]
      if file.type.match "image.*"
        reader = new FileReader
        reader.onload = (e) ->
          thumnail = e.target.result
          $("img.temporally-photo-url-#{index}").css
            "background-image": "url(#{thumnail})"
        reader.readAsDataURL file

        formData = new FormData
        formData.append "file", file
        temporallyPhoto.save formData,
          (response) ->
            $("img.temporally-photo-url-#{index}").show()

            url = response["temporally_photo_url"]
            $("input.temporally-photo-url-#{index}").val url

            $submitButton.removeAttr "disabled"
            $scope.add()
          , ->
            $submitButton.removeAttr "disabled"
      else
        $submitButton.removeAttr "disabled"
]
