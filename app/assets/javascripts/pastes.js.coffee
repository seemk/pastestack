# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#hide_history_btn").click ->
    table = $("#historyTable")
    if table.is ":hidden"
        table.show()
        $(this).text("hide")
    else
        table.hide()
        $(this).text("show")
    false