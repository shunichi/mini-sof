answer_container = $("#answer_<%= @answer.id %>")
answer_container.find(".answer-text").html("<%= escape_javascript(@answer.body) %>")
answer_container.find(".answer-text, .answer-links").show()
answer_container.find(".answer-edit-form").html("<%= escape_javascript(render partial: 'questions/answer_edit_form', locals: { answer: @answer } )%>")
answer_container.find(".answer-edit-form-container").hide()
