
startTime = 0;
timeLimit = 10000;

$(document).ready(function(){
  if ($("#question").length == 0) {
    return false;
  }
  startTime = Date.now();
  timer = startTimer();
  endTimer = setTimeout(timesUp, timeLimit);
  alreadyClicked = false;

  $(".option").click(function(event) {
    if (alreadyClicked) {
      return false;
    }
    alreadyClicked = true;
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
    $("#timer").css("width", "90%").addClass("answered");
    $("#timer").removeClass("yellow").removeClass("red");
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
    remaining = timeLimit - (Date.now() - startTime);
    percentage = remaining / timeLimit * 100;
    $("#timer").css("width", percentage + "%");
    if (remaining  < timeLimit/3.0) {
      $("#timer").removeClass("yellow")
      $("#timer").addClass("red")
    } else if (remaining < timeLimit/3.0 * 2) {
      $("#timer").addClass("yellow")
    }
  }

  return setInterval(setTimer, 300);
}

function timesUp() {
  $(".default-choice:first").click();
}
