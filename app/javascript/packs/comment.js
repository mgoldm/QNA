$(document).on('turbolinks:load', function () {
    $('form.new-comment').on('ajax:success', function (e) {
        let comm = e.detail[0].comment;
        let id = e.detail[0].commentable_id
        let type = e.detail[0].commentable_type
        if (type === 'Question') {
            $(`.question-comments`).append('<p>' + comm + '</p>');
        } else {
            $(`.answer[data-answer-id='${id}'`).append('<p>' + comm + '</p>');
        }
    })
})