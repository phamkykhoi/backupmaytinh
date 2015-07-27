@application.service "temporallyPhoto", ["$http", ($http) ->
  save: (data, callbackSuccess, callbackError) ->
    $http
      url: "/temporally_photos"
      method: "POST"
      headers: {
        "Content-Type": undefined
        "X-CSRF-Token": $("meta[name=csrf-token]").attr("content")
        "X-Requested-With": "XMLHttpRequest"
      }
      data: data
    .success (_data, status, headers, config) ->
      callbackSuccess _data
    .error (_data, status, headers, config) ->
      callbackError()
]
