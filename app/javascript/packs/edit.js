document.addEventListener('turbolinks:load', function () {
    const control = document.querySelector('.question-action')
    const buttonEdit = control.querySelector('.edit')
    const buttonSelect = control.querySelector('.select-best')
    const editQuestion = control.querySelector('.question-edit.hidden')

    let bestAnswer = document.querySelectorAll('.update-best.hidden')

    buttonEdit.addEventListener("click", function () {
        if (editQuestion.style.display == 'none') {
            editQuestion.style.display = 'block'
        } else {
            editQuestion.style.display = 'none'
        }
    })

    buttonSelect.addEventListener("click", function () {
        bestAnswer.forEach(function (item, i, bestAnswer) {

            if (item.style.display == 'none') {
                item.style.display = 'block'
            } else {
                item.style.display = 'none'
            }
        })
    })
})

