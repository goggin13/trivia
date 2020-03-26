
startTime = 0;
timeLimit = 5000;

$(document).ready(function(){
  startTime = Date.now();
  timer = startTimer();
  endTimer = setTimeout(timesUp, timeLimit);
  $(".option").click(function(event) {
    endTime = Date.now();
    duration = (endTime - startTime) / 1000.0;
    $this = $(this);
    path = $(this).children("a").first().attr("href");
    $.post(path, {duration: duration}, function(data, status, jqXHR) {
      if (data.correct) {
        $this.addClass("correct");
      } else {
        $this.addClass("incorrect");
        $("#option-" + data.correct_option.id).addClass("correct");
      }

      $(".option").fadeOut(2500);
      redirectTo(data.redirect);
    });

    clearInterval(timer);
    clearInterval(endTimer);
    $("#timer").html("Answered in " + duration + " seconds");
    return false;
  });
});

function redirectTo(nextHref) {
  redirect = function () {
    window.location.href = nextHref
  }
  setTimeout(redirect, 2500);
}

function startTimer() {
  setTimer = function () {
    duration = timeLimit - (Date.now() - startTime);
    $("#timer").html((duration / 1000).toFixed(1));
  }

  return setInterval(setTimer, 150);
}

function timesUp() {
  $(".default-choice:first").click();
}
