
$(document).ready(function(){
  $(".option").click(function(event) {
    $this = $(this);
    path = $(this).children("a").first().attr("href");
    $.post(path, {}, function(data, status, jqXHR) {
      if (data.correct) {
        $this.addClass("correct");
      } else {
        $this.addClass("incorrect");
        $("#option-" + data.correct_option.id).addClass("correct");
      }

      $(".option").fadeOut(2500);
      redirectToQuestion(data.next_question.id);
    });

    return false;
  });
});

function redirectToQuestion(questionId) {
  redirect = function () {
    console.log("next question!");
    window.location.href = '/questions/' + questionId;
  }
  setTimeout(redirect, 2500);
}
