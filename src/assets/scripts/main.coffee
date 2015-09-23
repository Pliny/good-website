Scroll = require('./scroll')
MyScrollSpy = require('./scrollspy')

height = 768
scroll

$(document).on('ready', () ->
  scroll = new Scroll($('.page:nth-of-type(2)'));
  scrollSpy = new MyScrollSpy($('.page'))

  $(document).on('click', '.arrow-down', () ->
    scroll.animateScrollFor(1000)
  )
)

