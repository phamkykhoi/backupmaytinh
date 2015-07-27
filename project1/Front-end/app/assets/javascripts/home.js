$(document).ready(function() {

  $(".delete_ans").on('click', function() {
    id = parseInt($(this).attr("id"));
    $("#word_answers_attributes_"+id+"__destroy").prop('value', true);
    $(this).parent().parent().slideUp(100).remove();
    number = 1;
    $('.label_answer').each(function(){
        $(this).attr("number",number);
        $(this).html("Answer "+ number);
        number++
    });
  })

  $(".answer_radio").on('click', function() {
    $(".answer_radio").prop('checked', false);
    $(".answer_radio").prop('value', false);
    $(this).prop('checked', true);
    $(this).prop('value', true);
  })
})