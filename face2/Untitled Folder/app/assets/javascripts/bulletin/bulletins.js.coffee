wrapIframe = (iframe, aspectRatio) ->
  parent = iframe.parentNode
  clone = iframe.cloneNode true
  newParent = iframe.ownerDocument.createElement('div')
  paddingTop = Math.floor(aspectRatio * 100 * 100) / 100
  newParent.className = 'movie'
  newParent.style.paddingTop = paddingTop + '%'
  if parent
    newParent.appendChild clone
    parent.replaceChild newParent, iframe
  else
    newParent.appendChild iframe

fitIframe = ->
  iframe = document.getElementById('to_fit')
  width = iframe.width
  height = iframe.height
  aspectRatio = height / width
  wrapIframe(iframe, aspectRatio)

$(document).ready(fitIframe)
$(document).on('page:load', fitIframe)
