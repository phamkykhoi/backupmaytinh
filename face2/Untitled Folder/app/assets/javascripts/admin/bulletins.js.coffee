# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
mixed = ->
  $('#bulletin_content').trumbowyg()

  $("#strech_fold dt").click ->
    $(this).next().slideToggle()

$(document).ready(mixed)
$(document).on('page:load', mixed)
