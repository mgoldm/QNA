import consumer from './consumer'

$(document).on('turbolinks:load', function () {
    if (gon.question_id !== null) {
        consumer.subscriptions.create({channel: 'CommentsChannel', question_id: gon.question_id}, {
            received(data) {

                if (data.commentable_type === 'Question') {
                    $('.question-comments').append(data.comment)
                } else {
                    $(`.answer-comments[data-answer-id='${data.commentable_id}']`).append(data.comment)
                }
                if (gon.user_id) {
                    if (gon.user_id !== data.commentable_author_id) {
                        $(`.answer[data-answer-id='${data.commentable_id}'].answer-author`).remove()
                    }
                } else {
                    $(`.answer[data-answer-id='${data.commentable_id}'].question-author`).remove()
                    $(`.answer[data-answer-id='${data.commentable_id}'].answer-author`).remove()
                }
            }
        })
    }
})