ready = ->
	showAnswerEditForm = (target) ->
		a = target.closest(".answer")
		a.find('.answer-text, .answer-links').hide()
		a.find('.answer-edit-form-container').show()
		a.find('textarea').val(a.find('.md-plain').text())
	hideAnswerEditForm = (target) ->
		a = target.closest('.answer')
		a.find('.answer-text, .answer-links').show()
		a.find('.answer-edit-form-container').hide()

	$(".answer-edit-link").click (e) ->
		e.preventDefault()
		showAnswerEditForm($(e.currentTarget))
	$(".answer-edit-cancel-link").click (e) ->
		e.preventDefault()
		hideAnswerEditForm($(e.currentTarget))
	$('.edit_answer').on('ajax:complete',
		(e, data, status, xhr) ->
			container = $(e.currentTarget).closest('.md-container')
			container.find('.md-plain').text(data.responseJSON.answer.body)
			renderMarkdown(container)
			hideAnswerEditForm(container)
	)

	updateAnswerCheck = (accepted_answer_id) ->
		$('.accepted')
			.removeClass('accepted-on')
			.addClass('accepted-off')
		if accepted_answer_id
			$('#answer_' + accepted_answer_id + ' .accepted')
				.removeClass('accepted-off')
				.addClass('accepted-on')
	$('.accept-link').click (e) ->
		target = $(e.currentTarget)
		url = if target.hasClass('accepted-off')
				target.data('acceptUrl')
			else
				target.data('unacceptUrl')
		$.ajax(
			type: "POST"
			url: url
			success: (data) ->
				updateAnswerCheck(data.answer.id)
				return false
			error: (data) ->
				alert('エラーが発生しました')
				return false
			)

	hilightVoteArrow = (parent,value) ->
		parent.find('.vote-arrow.upvote, .vote-arrow.downvote').removeClass('voted')
		if value > 0
			parent.find('.vote-arrow.upvote').addClass('voted')
		else if value < 0
			parent.find('.vote-arrow.downvote').addClass('voted')
	$('.vote-arrow.upvote, .vote-arrow.downvote').click (e) ->
		target = $(e.currentTarget)
		parent = target.parent()
		$.ajax(
			type: "POST"
			url: target.data('url')
			success: (data) ->
				parent.find('.votes-score').text( data.votes_score )
				hilightVoteArrow(parent, data.vote_value)
				return false
			error: (data) ->
				alert('エラーが発生しました')
				return false
			)

	renderMarkdown = (container) ->
		text = container.find('.md-plain').text()
		formatted = marked(text, {
			sanitize: true
			})
		container.find('.md-formatted').html(formatted)
	$('.md-container').each( (i, elem) -> renderMarkdown($(elem)) )

	updateMarkdownPreview = ->
		text = $('.edit textarea').val()
		if text
			markuped = marked(text, {
				sanitize: true
				})
			$('.preview-text').html(markuped)
	$('.edit textarea').keyup (e) ->
		updateMarkdownPreview()
	updateMarkdownPreview()

	tabHandler = (e) ->
		keyCode = e.keyCode || e.which
		if keyCode == 9
		    e.preventDefault()
		    start = $(this).get(0).selectionStart
	    	end = $(this).get(0).selectionEnd

		    # set textarea value to: text before caret + tab + text after caret
		    $(this).val(
		    	$(this).val().substring(0, start) +
		    	"\t" +
		    	$(this).val().substring(end)
		    	)

	 	    # put caret at right position again
		    $(this).get(0).selectionStart =
			    $(this).get(0).selectionEnd = start + 1
	$(document).on('keydown', '.edit textarea', tabHandler )
$(document).ready(ready)
$(document).on('page:load', ready)
