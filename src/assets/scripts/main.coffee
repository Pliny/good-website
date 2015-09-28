Scroll = require('./scroll')
MyScrollSpy = require('./scrollspy')

SCREENSMMIN = 768

scroll

PageCopy = {
  '#page1 > .header > h1' : { 'smallScreen' : "Save Water",   'largeScreen' : "Internet of Water Things" },
  '#page2 > .header > h1' : { 'smallScreen' : "Impact",       'largeScreen' : "Meaningful Impact"        },
  '#page3 > .header > h1' : { 'smallScreen' : "About Us",     'largeScreen' : "About Us"                 },
  '#page4 > .header > h1' : { 'smallScreen' : "Here To Help", 'largeScreen' : "We Want To Help"          },
  'footer > span'         : { 'smallScreen' : "(C) 2015 good Inc.", 'largeScreen' : "Copyright 2015 good Inc. All rights reserved with love. " }
}

setTextFor = (screenSize) ->
    for ele, textObj of PageCopy
      $(ele).text(textObj[screenSize])

setView = () ->
  height = $(document).height()

  setHeightEle = '.set-height'

  if $(document).width() < SCREENSMMIN
    setTextFor('smallScreen')
  else
    setHeightEle += ', .page'
    setTextFor('largeScreen')

  $('.arrow-down').css('top', height-(height*0.075))

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

