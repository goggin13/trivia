
startTime = 0;
timeLimit = 2000;

$(document).ready(function(){
  startTime = Date.now();
  timer = startTimer();
  endTimer = setTimeout(timesUp, timeLimit);
  $(".option").click(function(event) {
    $this = $(this);
    path = $(this).children("a").first().attr("href");
    $(".option").off("click");
    $(".option a").attr("href", "#");
    endTime = Date.now();
    duration = (endTime - startTime) / 1000.0;
    $.post(path, {duration: duration}, function(data, status, jqXHR) {
      if (data.correct) {
        $this.addClass("correct");
      } else {
        $this.addClass("incorrect");
        $("#option-" + data.correct_option.id).addClass("correct");
      }

      $("#answers").fadeOut(1500);
      redirectTo(data.redirect);
    });

    clearInterval(timer);
    clearInterval(endTimer);
    $("#timer").html("Answered in " + duration + " seconds");
    $("#timer").removeClass("yellow").removeClass("red");
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
    remaining = timeLimit - (Date.now() - startTime);
    $("#timer").html((remaining  / 1000).toFixed(1));
    if (remaining  < timeLimit/3.0) {
      $("#timer").removeClass("yellow")
      $("#timer").addClass("red")
    } else if (remaining < timeLimit/3.0 * 2) {
      $("#timer").addClass("yellow")
    }
  }

  return setInterval(setTimer, 150);
}

function timesUp() {
  $(".default-choice:first").click();
}
