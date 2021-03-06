$(document).on('turbolinks:load', function () {
    console.log('123')
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    })

    $('form.new-answer').on('ajax:success', function (e) {
        let answer = e.detail[0];

        $('.answers').append('<p>' + answer.title + ' ' + answer.correct + '</p>');
    })
        .on('ajax:error', function (e) {
            let errors = e.detail[0];

            $.each(errors, function (index, value) {
                $('.answer-errors').append('<p>' + value + '</p>')
            })
        })
    $('form.update-count').on('ajax:success', function (e) {
        console.log(e.detail);
        let value = e.detail[0].answer_count

        $('.pointer').replaceWith('<p>' + value + '</p>');

    })
});