class MyScrollSpy
  constructor: (@$actionSelectors) ->

    $(document).on('scroll', (e) =>
      $actionSelectors = @$actionSelectors
      @$actionSelectors.filter(':not([class~=active])').each(() ->
        scrollOffset = window.document.documentElement.scrollTop or window.document.body.scrollTop
        if scrollOffset >= this.offsetTop-200 and scrollOffset < this.offsetTop-200 + this.offsetHeight
          $actionSelectors.removeClass('active').children('.header-container').addClass('hidden')
          $(this).addClass('active').children('.header-container').removeClass('hidden')
          return false
      )
    )

module.exports = MyScrollSpy
