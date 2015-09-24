Scroll = require('./scroll')
MyScrollSpy = require('./scrollspy')

SCREENSMMIN = 768

scroll

setView = () ->
  height = $(document).height()

  setHeightEle = '.set-height'

  if $(document).width() < SCREENSMMIN
    $("footer > span").text("(C) 2015 good Inc. ")
  else
    setHeightEle += ', .page'
    $("footer > span").text("Copyright 2015 good Inc. All rights reserved with love. ")

  $(setHeightEle).css('height', height)
  $('footer, #container').removeClass('hidden')

$(document).on('ready', () ->
  setView()
  scroll = new Scroll($('.page:nth-of-type(2)'));
  scrollSpy = new MyScrollSpy($('.page'))

  $(document).on('click', '.arrow-down', () ->
    scroll.animateScrollFor(1000)
  )
)

