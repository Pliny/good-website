class MyScrollSpy
  constructor: (@$actionSelectors) ->

  updateHeaderMaybe: (scrollOffset) ->
      $actionSelectors = @$actionSelectors
      @$actionSelectors.filter(':not([class~=active])').each(() ->
        if scrollOffset >= this.offsetTop-200 and scrollOffset < this.offsetTop-200 + this.offsetHeight
          if not $(this).hasClass('active')
            $actionSelectors.removeClass('active')
            $(this).addClass('active')

            $('header  ul > li').addClass('hidden')
            $('#' + $(this).attr('use-header')).removeClass('hidden')

            timeInSec = Math.floor((new Date).getTime()/1000)
            ga('send', 'event', 'section', 'viewed', "userPassed-" + $(this).attr('use-header'), timeInSec)

          return false
      )

module.exports = MyScrollSpy
