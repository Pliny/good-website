class MyScrollSpy
  constructor: (@$actionSelectors) ->

  updateHeaderMaybe: (scrollOffset) ->
      $actionSelectors = @$actionSelectors
      @$actionSelectors.filter(':not([class~=active])').each(() ->
        if scrollOffset >= this.offsetTop-200 and scrollOffset < this.offsetTop-200 + this.offsetHeight
          $actionSelectors.removeClass('active')
          $(this).addClass('active')

          $('header  ul > li').addClass('hidden')
          $('#' + $(this).attr('use-header')).removeClass('hidden')

          return false
      )

module.exports = MyScrollSpy
