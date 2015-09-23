class MyScrollSpy
  constructor: (@$actionSelectors) ->

    $(document).on('scroll', (e) =>
      $actionSelectors = @$actionSelectors
      @$actionSelectors.filter(':not([class~=active])').each(() ->
        scrollOffset = window.document.documentElement.scrollTop or window.document.body.scrollTop
        if scrollOffset >= this.offsetTop-2 and scrollOffset < this.offsetTop-2 + this.offsetHeight
          # if not $(this).hasClass('active')
          $actionSelectors.removeClass('active').children('.header').addClass('hidden')
          $(this).addClass('active').children('.header').removeClass('hidden')
          return false
      )
    )

module.exports = MyScrollSpy
