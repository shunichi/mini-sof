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
$(document).ready(ready)
$(document).on('page:load', ready)
