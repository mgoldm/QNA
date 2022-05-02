import consumer from './consumer'

$(document).on('turbolinks:load', function () {
    if (gon.question_id !== null) {
        consumer.subscriptions.create({channel: 'AnswersChannel', question_id: gon.question_id}, {
            received(data) {
                $('.answers').append(data.answer)

                if (gon.user_id) {
                    if (gon.user_id !== data.answer_author_id) {
                        $(`.answer[data-answer-id='${data.answer.id}'].answer-author`).remove()
                    }
                    if (gon.user_id !== data.question_author_id) {
                        $(`.answer[data-answer-id='${data.answer.id}'].question-author`).remove()
                    }
                } else {
                    $(`.answer[data-answer-id='${data.answer.id}'].question-author`).remove()
                    $(`.answer[data-answer-id='${data.answer.id}'].answer-author`).remove()
                }
            }
        })
    }
})