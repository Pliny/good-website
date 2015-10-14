class RingAnimation

  constructor: (data) ->
    @_$ring      = $(data['selector'])
    @_ele       = @_$ring.children()
    @_timeMs     = data['timeMs']
    @_eleHeight  = Math.ceil(@_$ring.height() / (@_$ring.children().length))
    @_eleIdx     = 0

    $.each(@_ele.slice(1, @_ele.length), (idx, val) ->
      $(val).addClass('see-through')
    )

    firstEleHeight = @_currLoc = (@_eleHeight * (@_ele.length - 1))
    @_$ring.css('transform', 'translateY(' + firstEleHeight + 'px)')
    setTimeout(() =>
      @_$ring.addClass('adv-anim')
      $.each(@_ele, (idx, val) ->
        $(val).addClass('adv-anim-ele')
      )
    ,0)

  start: () ->
    @_timer = setInterval(@_step, @_timeMs)

  stop: () ->
    clearInterval(@_timer) if @_timer

  _step: () =>
    if not (@_currLoc <= 0)
      @_currLoc = @_currLoc - @_eleHeight
      @_$ring.css('transform', 'translateY(' + @_currLoc + 'px)')
      $(@_ele[@_eleIdx]).addClass('see-through')
      @_eleIdx++
      $(@_ele[@_eleIdx]).removeClass('see-through')
      if @_eleIdx == @_ele.length - 1
        $(@_ele[@_eleIdx]).addClass('text-blur')
    else
      @stop()

module.exports = RingAnimation

