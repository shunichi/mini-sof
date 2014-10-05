ready = ->
    showAnswerEditForm = (target) ->
        a = target.closest(".answer")
        a.find('.answer-text, .answer-links').hide()
        a.find('.answer-edit-form-container').show()
        a.find('textarea').val(a.find('.md-plain').text())
        updateMarkdownPreview(a)
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

    highlightVoteArrow = (parent,value) ->
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
                highlightVoteArrow(parent, data.vote_value)
                return false
            error: (data) ->
                alert('エラーが発生しました')
                return false
            )

    renderMarkdown = (container) ->
        text = container.find('.md-plain').text()
        formatted = marked(text, sanitize: true)
        container.find('.md-formatted').html(formatted)
    $('.md-container').each (i, elem) ->
        renderMarkdown($(elem))

    updateMarkdownPreview = (container) ->
        text = container.find('.md-edit-textarea').val()
        if text?
            formatted = marked(text, sanitize: true)
            container.find('.md-edit-preview').html(formatted)
    $('.md-edit-textarea').on 'input', (e) ->
        container = $(e.currentTarget).closest('.md-edit-container')
        updateMarkdownPreview(container)
    $('.md-edit-container').each (i, elem) ->
        updateMarkdownPreview($(elem))

    tabHandler = (e) ->
        keyCode = e.keyCode || e.which
        if keyCode == 9
            console.log("TAB")
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
    if !document.tabHadlerIntalled
        $(document).on('keydown', 'textarea', tabHandler)
        document.tabHadlerIntalled = true
$(document).ready(ready)
$(document).on('page:load', ready)
