$(document).on('ready', () ->
  html_contents = $('#container').html()
  coffee_test_contents = "<h1>Coffeescript and browserify works.<h1>"
  $('#container').html(html_contents + coffee_test_contents)
)
