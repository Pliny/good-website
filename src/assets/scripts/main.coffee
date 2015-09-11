Scroll = require('./scroll')

height = 768
scroll

setView = () ->
  height = $(document).height()
  $('.page').css('height', height).css('display', 'block')
  $('footer').removeClass('hidden')

$(document).on('ready', () ->
  setView()
  scroll = new Scroll($('.page:nth-of-type(2)'));

  $('.arrow-down').on('click', () ->
    scroll.animateScrollFor(1000)
  )
)

