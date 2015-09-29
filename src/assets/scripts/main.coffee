Scroll = require('./scroll')
MyScrollSpy = require('./scrollspy')

SCREENSMMIN = 768

scroll
height = 768

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
  $('#water-animation-initial').addClass('slow-fade-in')
  $('footer, #container, #water-animation-initial').removeClass('hidden')

$(document).on('ready', () ->
  setView()
  scroll = new Scroll($('#page1'))
  scrollSpy = new MyScrollSpy($('.page'))

  setTimeout(() ->
    $('#water-animation-initial').css('height', '80%')
    setTimeout(() ->
      $('#water-animation-initial').css('height', '33%')
      setTimeout(() ->
        $('#water-animation-initial').css('height', '100%')
        setTimeout(() ->
          $('#water-animation-initial').removeClass('in-front').removeClass('blurry-top')
          $('.water-animation-final').removeClass('hidden').addClass('slow-fade-in')
        4000)
      4000)
    4000)
  1000)

  setTimeout(() ->
    $('#problem1').removeClass('hidden').addClass('fade-in-and-out').css('top', height*0.50)
    setTimeout(() ->
      $('#problem1').removeClass('fade-in-and-out').addClass('hidden')
      $('#problem2').removeClass('hidden').addClass('fade-in-and-out').css('top', height*0.70)
    3500)
  2500)

  $(document).on('click', '.arrow-down', () ->
    scroll.animateScrollFor(1000)
  )

  $(document).on('animationend', '.fade-in-and-out', () ->
    $(this).removeClass('fade-in-and-out').addClass('hidden')
  )
)

