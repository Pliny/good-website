IScrollManager       = require('./scrollManager').IScrollManager
ClassicScrollManager = require('./scrollManager').ClassicScrollManager

SCREENSMMIN = 768

height = 768
scroll = null

PageCopy = {
  '#header1 > .header > h1' : { 'smallScreen' : "Save Water",   'largeScreen' : "Internet of Water Things" },
  '#header2 > .header > h1' : { 'smallScreen' : "Impact",       'largeScreen' : "Meaningful Impact"        },
  '#header3 > .header > h1' : { 'smallScreen' : "About Us",     'largeScreen' : "About Us"                 },
  '#header4 > .header > h1' : { 'smallScreen' : "Here To Help", 'largeScreen' : "We Want To Help"          },
  'footer > span'         : { 'smallScreen' : "(C) 2015 good Inc.", 'largeScreen' : "Copyright 2015 good Inc. All rights reserved with love. " }
}

setTextFor = (screenSize) ->
    for ele, textObj of PageCopy
      $(ele).text(textObj[screenSize])

setView = () ->
  height = $(document).height()

  if $(document).width() < SCREENSMMIN
    setTextFor('smallScreen')
  else
    setTextFor('largeScreen')

  $('.arrow-down').css('top', height-(Math.round(height*0.075)))

  $('.set-height').css('height', height)
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
  fadeAnimDur = Math.round(0.30*initAnimDur)

  setTimeout(() ->
    $('#problem1').addClass('fade-in-and-out').css('top', Math.round(height*0.55))
    $('.fade-in-and-out').css('animation-duration', fadeAnimDur+"ms")
  ,(initAnimDur*0.39)-(fadeAnimDur/1.5))

  setTimeout(() ->
    $('#problem2').addClass('fade-in-and-out').css('top', Math.round(height*0.75))
    $('.fade-in-and-out').css('animation-duration', fadeAnimDur+"ms")
  ,(initAnimDur*0.69)-(fadeAnimDur/1.5))

  $(document).on('animationend webkitAnimationEnd oanimationend MSAnimationEnd', '.initial-anim', () ->
    $('.problems').addClass('hidden')
    $('.water-animation-final').removeClass('hidden')

    if scroll.y() < 8
      timeInSec = Math.floor((new Date).getTime()/1000)
      ga('send', 'event', 'frontPageAnimation', 'viewed', 'userWatchedAnimationFinish', timeInSec)
  )


$(document).on('ready', () ->
  setView()

  manageInitialAnimation()

  if navigator.userAgent.match(/iPhone|iPad|iPod/i)
    scroll = new IScrollManager($('.page'))
  else
    scroll = new ClassicScrollManager($('.page'))
)

