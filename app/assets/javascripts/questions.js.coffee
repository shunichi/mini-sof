# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$(".answer-edit-link").click (e) ->
		e.preventDefault()
		a = $(e.currentTarget).closest(".answer")
		a.find('.answer-text, .answer-links').hide()
		a.find('.answer-edit-form').show()
	$(".answer-edit-cancel-link").click (e) ->
		e.preventDefault()
		a = $(e.currentTarget).closest(".answer")
		a.find('.answer-text, .answer-links').show()
		a.find('.answer-edit-form').hide()
