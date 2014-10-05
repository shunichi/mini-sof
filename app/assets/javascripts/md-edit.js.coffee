updateMarkdownPreview = (container) ->
    text = container.find('.md-edit-textarea').val()
    if text?
        formatted = marked(text, sanitize: true)
        container.find('.md-edit-preview').html(formatted)

ready = ->
    $('.md-edit-textarea').on 'input', (e) ->
        container = $(e.currentTarget).closest('.md-edit-container')
        updateMarkdownPreview(container)
    $('.md-edit-container').each (i, elem) ->
        updateMarkdownPreview($(elem))

$(document).ready(ready)
$(document).on('page:load', ready)
