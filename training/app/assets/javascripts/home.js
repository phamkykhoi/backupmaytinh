$(document).ready(function(){
    $(".insertanswer").click(function() {
        var numItems = parseInt($('.label_answer').length)
        html  = '<div class="form-group">';
        html += '<label class="label_answer">Answer&nbsp</label>';
        html += '<span class="pull-right">Is true <input type="radio" name="question[answers_attributes]['+numItems+'][status]" id="0" value="" class="answer_radio" /></span>';
        html += '<div class="input-group">';
        html += '<textarea class="form-control" name="question[answers_attributes]['+numItems+'][body]" class="content_ans"></textarea>';
        html += '<span class="input-group-addon delete_ans"><i class="glyphicon glyphicon-remove"></i></span></div>';
        html += '</div>';
    	$("#answer").append(html);
    });

    $(".delete_ans").live("click", function() {
    	$(this).parent().parent().slideUp(100).remove();
        thutu = 1;
        $('.label_answer').each(function(){
            $(this).attr("thutu",thutu);
            $(this).html("Answer");
            thutu++
        });
    })

    $(".answer_radio").live('click', function(){
        $(".answer_radio").prop('checked', false);
        $(".answer_radio").prop('value', false);
        $(this).prop('checked', true);
        $(this).prop('value', true);
        
        var question_id = $("#question").val();
        var answer_id   = parseInt($(this).attr("id"));


        $.ajax({
            url: "/update-status-answer",
            type: "POST",
            data: "question_id="+question_id+"&answer_id="+answer_id,
            async: true
        });
    })
})