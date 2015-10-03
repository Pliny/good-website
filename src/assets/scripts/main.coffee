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
  $('#water-animation-element').addClass('initial-anim')
  $('footer, #container, #water-animation-element').removeClass('hidden')

getAnimMs = ($animatedEle) ->
  dur = $animatedEle.css('animation-duration')
  if dur.search(/ms$/) > 0
    dur = dur.substring(0, dur.length-2)
  else if dur.search(/s$/) > 0
    dur = dur.substring(0, dur.length-1)
    dur *= 1000
  else
    console.log("ERROR in animation time in '"+$animatedEle+"'.")
    dur = 0

  return dur

manageInitialAnimation = () ->
  initAnimDur = getAnimMs($('#water-animation-element'))
  fadeAnimDur = 0.23*initAnimDur

  setTimeout(() ->
    $('#problem1').addClass('fade-in-and-out').css('top', height*0.50)
    $('.fade-in-and-out').css('animation-duration', fadeAnimDur+"ms")
  ,(initAnimDur*0.39)-(fadeAnimDur/1.5))

  setTimeout(() ->
    $('#problem2').addClass('fade-in-and-out').css('top', height*0.60)
    $('.fade-in-and-out').css('animation-duration', fadeAnimDur+"ms")
  ,(initAnimDur*0.69)-(fadeAnimDur/1.5))

  $(document).on('animationend webkitAnimationEnd oanimationend MSAnimationEnd', '.initial-anim', () ->
    $('.problems').addClass('hidden')
    $('.water-animation-final').removeClass('hidden')
  )


$(document).on('ready', () ->
  setView()
  scroll = new Scroll($('#page1'))
  scrollSpy = new MyScrollSpy($('.page'))

  manageInitialAnimation()

  $(document).on('click', '.arrow-down', () ->
    scroll.animateScrollFor(1000)
  )
)

