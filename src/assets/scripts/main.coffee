
$(document).on('ready', () ->
  height = $(document).height()
  $('.page').css('height', height).css('display', 'block')
  $('footer').removeClass('hidden')
)
