$ ->
  for action in ["dragover", "dragenter", "drop"]
    $("body").on action, (e) ->
      e.stopPropagation()
      e.preventDefault()

  $("#post_m_genre_id").select2
    width: "400px"
    minimumResultsForSearch: 10

  $("#post_camera_id").select2
    width: "400px"
    multiple: false
    ajax: {
      url: "/cameras"
      dataType: "json"
      quietMillis: 500
      data: (search, page) ->
        q: {name_cont_any: search}
      results: (data, page) ->
        cameras = []
        for camera in data["cameras"]
          cameras.push
            id: camera.id
            text: camera.name
        {results: cameras}
    }
    createSearchChoice: (term, data) ->
      if ($(data).filter(-> this.text.localeCompare(term) == 0).length == 0)
        {id: "new_camera_#{term}",  text: term}
    initSelection: (el, callback)->
      id = $(el).data("id")
      text = $(el).data("name")
      if id && text
        callback {id: id, text: text}

  $("#post_tag_ids").select2
    width: "400px"
    multiple: true
    ajax: {
      url: "/tags"
      dataType: "json"
      quietMillis: 500
      data: (search, page) ->
        q: {name_cont_any: search}
      results: (data, page) ->
        tags = []
        for tag in data["tags"]
          tags.push
            id: tag.id
            text: tag.name
        {results: tags}
    }
    createSearchChoice: (term, data) ->
      if ($(data).filter(-> this.text.localeCompare(term) == 0).length == 0)
        {id: "new_tag_#{term}", text: term}
    initSelection: (el, callback)->
      tags = $(el).data("tags")
      unless tags == []
        _tags = []
        for tag in tags
          _tags.push {id: tag["id"], text: tag["name"]}
        callback _tags

  $("#post_photographer_id").select2
    width: "400px"
    multiple: false
    ajax: {
      url: "/users"
      dataType: "json"
      quietMillis: 700
      data: (search, page) ->
        q: {name_cont_any: search}
      results: (data, page) ->
        users = []
        for user in data["users"]
          users.push
            id: user.id
            text: user.name
        {results: users}
    }
    createSearchChoice: (term, data) ->
      if ($(data).filter(-> this.text.localeCompare(term) == 0).length == 0)
        {id: "new_user_#{term}", text: term}
    initSelection: (el, callback)->
      id = $(el).data("id")
      text = $(el).data("name")
      if id && text
        callback {id: id, text: text}

  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (pos) ->
      $location = $("#post_location")
      $location.select2("destroy").attr "style", ""
      $location.select2
        width: "400px"
        multiple: false
        ajax: {
          url: "/places"
          dataType: "json"
          quietMillis: 2000
          data: (search, page) ->
            ll: "#{pos.coords.latitude},#{pos.coords.longitude}"
            query: search
          results: (data, page) ->
            places = []
            for place in data["places"]
              places.push
                id: place.name
                text: place.name
            {results: places}
        }
        createSearchChoice: (term, data) ->
          if ($(data).filter(-> this.text.localeCompare(term) == 0).length == 0)
            {id: term, text: term}
        initSelection: (el, callback)->
          text = $(el).data("name")
          if text
            callback {id: text, text: text}

  $("#post_location").select2
    width: "400px"
    multiple: false
    ajax: {
      url: "/places"
      dataType: "json"
      quietMillis: 2000
      data: (search, page) ->
        query: search
      results: (data, page) ->
        places = []
        for place in data["places"]
          places.push
            id: place.name
            text: place.name
        {results: places}
    }
    createSearchChoice: (term, data) ->
      if ($(data).filter(-> this.text.localeCompare(term) == 0).length == 0)
        {id: term, text: term}
    initSelection: (el, callback)->
      text = $(el).data("name")
      if text
        callback {id: text, text: text}
