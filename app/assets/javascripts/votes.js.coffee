highlightVoteArrow = (parent,value) ->
    parent.find('.vote-arrow.upvote, .vote-arrow.downvote').removeClass('voted')
    if value > 0
        parent.find('.vote-arrow.upvote').addClass('voted')
    else if value < 0
        parent.find('.vote-arrow.downvote').addClass('voted')

ready = ->
    $('.vote-arrow.upvote, .vote-arrow.downvote').click (e) ->
        target = $(e.currentTarget)
        parent = target.parent()
        $.ajax(
            type: "POST"
            url: target.data('url')
            success: (data) ->
                parent.find('.votes-score').text( data.votes_score )
                highlightVoteArrow(parent, data.vote_value)
                return false
            error: (data) ->
                alert('エラーが発生しました')
                return false
            )

$(document).ready(ready)
$(document).on('page:load', ready)
