MyScrollSpy = require('./scrollspy')
Scroll = require('./scroll')

class ScrollManager
  constructor: ($ele) ->
    @scrollSpy = new MyScrollSpy($ele)

  y: () ->
    console.log("ERROR: Calling an abstract function.")

class IScrollManager extends ScrollManager

  constructor: ($ele) ->
    super $ele
    @iScroll = new IScroll('#wrapper', { tap: true, probeType: 3, mouseWheel: true })
    @iScroll.on('scroll', () =>
      @scrollSpy.updateHeaderMaybe(@y())
    )

    $(document).on('touchmove', (e) ->
      e.preventDefault()
    )
    $(document).on('tap', '.arrow-down', () =>
      @iScroll.scrollToElement('#page1', 1000, null, null, IScroll.utils.ease.quadratic)
    )

  y: () ->
    return -1*@iScroll.y

class ClassicScrollManager extends ScrollManager

  constructor: ($ele) ->
    super $ele

    $('#wrapper').removeClass('hide-overflow')
    $(document).on('scroll', (e) =>
      @scrollSpy.updateHeaderMaybe(@y())
    )

    @classicScroll = new Scroll($('#page1'))
    $(document).on('click touchend', '.arrow-down', () =>
      @classicScroll.animateScrollFor(1000)
    )

  y: () ->
    return window.document.documentElement.scrollTop or window.document.body.scrollTop

module.exports.IScrollManager       = IScrollManager
module.exports.ClassicScrollManager = ClassicScrollManager
