Scroll = require('./scroll')
MyScrollSpy = require('./scrollspy')

height = 768
scroll

setView = () ->
  height = $(document).height()
  $('.page').css('height', height)
  $('footer, #container').removeClass('hidden')

$(document).on('ready', () ->
  setView()
  scroll = new Scroll($('.page:nth-of-type(2)'));
  scrollSpy = new MyScrollSpy($('.page'))

  $(document).on('click', '.arrow-down', () ->
    scroll.animateScrollFor(1000)
  )
)

