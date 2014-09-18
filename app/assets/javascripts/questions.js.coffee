ready = ->
	$(".answer-edit-link").click (e) ->
		e.preventDefault()
		a = $(e.currentTarget).closest(".answer")
		a.find('.answer-text, .answer-links').hide()
		a.find('.answer-edit-form-container').show()
	$(".answer-edit-cancel-link").click (e) ->
		e.preventDefault()
		a = $(e.currentTarget).closest(".answer")
		a.find('.answer-text, .answer-links').show()
		a.find('.answer-edit-form-container').hide()
	update_answer_check = (accepted_answer_id) ->
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
				update_answer_check(data.answer.id)
				return false
			error: (data) ->
				alert('エラーが発生しました')
				return false
			)
	hilightVoteArrow = (value) ->
		$('.question-upvote, .question-downvote').removeClass('question-voted')
		if value > 0
			$('.question-upvote').addClass('question-voted')
		else if value < 0
			$('.question-downvote').addClass('question-voted')
	$('.question-upvote, .question-downvote').click (e) ->
		target = $(e.currentTarget)
		$.ajax(
			type: "POST"
			url: target.data('url')
			success: (data) ->
				$('.question-vote-sum').text( data.vote_sum )
				hilightVoteArrow(data.vote_value)
				return false
			error: (data) ->
				alert('エラーが発生しました')
				return false
			)
$(document).ready(ready)
$(document).on('page:load', ready)
