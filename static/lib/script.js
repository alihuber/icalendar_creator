$(document).ready(function() {

  var language = window.navigator.userLanguage || window.navigator.language;
  var dateformat = '';
  if(language == 'de') {
    dateformat = "dd.mm.yyyy";
  } else {
    dateformat = "mm/dd/yyyy";
  }

  $("#clearButton").click(function() {
    clearEntries();
  });

  // clear all inputs
  function clearEntries() {
    // remove all error css
    $("[id^=input]").each(function() {
        $(this).closest('.control-group').removeClass('error');
        errorCount = 0;
    });

    $("[id^=input]").each(function(){
      $(this).attr('value', '');
    });
    $("#wholeDayCheckbox").prop('checked', false);
    $("#inputStartTime").prop({
      disabled: false
    });
    $("#inputEndTime").prop({
      disabled: false
    });
  }

  // set time disabled when all-day is checked
  $("#wholeDayCheckbox").change(function(){
    if($(this).is(':checked')) {
      $("#inputStartTime").prop({
        disabled: true
      });
      $("#inputEndTime").prop({
        disabled: true
      });
    } else {
      $("#inputStartTime").prop({
        disabled: false
      });
      $("#inputEndTime").prop({
        disabled: false
      });
    }
  });

  // toggle date/timepickers
  $("#inputStartDate").datepicker({
    format: dateformat
  });
  $("#inputEndDate").datepicker({
    format: dateformat
  });

  $("#inputStartTime").timepicker({
    showMeridian: false,
    minuteStep: 1,
  });
  $("#inputEndTime").timepicker({
    showMeridian: false,
    minuteStep: 1,
  });

  // max. 7 errors
  var errorCount = 0;

  // handle not filled out forms
  function checkForm() {

    // checking again: remove all errors
    $("[id^=input]").each(function() {
        $(this).closest('.control-group').removeClass('error');
        errorCount = 0;
    });


    $("[id^=input]").each(function() {
      if($(this).attr('value') == '' && !$(this).attr('disabled')) {
        $(this).closest('.control-group').addClass('error');
        errorCount += 1;
      }
    });


    checkDates();
  }


  // handle incorrect dates
  function checkDates() {

    var date1 = $("[id=inputStartDate]").attr('value');
    var date2 = $("[id=inputEndDate]").attr('value');

    // "dd.mm.yyyy"
    // "mm/dd/yyyy";
    // Objectname = new Date(Year, Month, Day);

    var dateary1;
    var dateary2;

    if(language == "de") {

      dateary1 = date1.split(".");
      dateary2 = date2.split(".");

      var year1 = parseInt(dateary1[2]);
      var year2 = parseInt(dateary2[2]);

      var month1 = parseInt(dateary1[1]);
      var month2 = parseInt(dateary2[1]);

      var day1 = parseInt(dateary1[0]);
      var day2 = parseInt(dateary2[0]);

      var compDate1 = new Date(year1, month1, day1);
      var compDate2 = new Date(year2, month2, day2);

      if(compDate2 < compDate1) {
        $("[id=inputEndDate]").closest('.control-group').addClass('error');
        alert('funzt');
        errorCount += 1;
      }

    } else  {
      var compDate1 = new Date(date1);
      var compDate2 = new Date(date2);
      if(compDate2 < compDate1) {
        alert('funzt');
        $("[id=inputEndDate]").closest('.control-group').addClass('error');
        errorCount += 1;
      }
    }
  }



  // ajax and UI for add event
  $('#eventForm').submit(function(event){

    event.preventDefault();

    // when errors found: don't submit
    checkForm();
    if(errorCount > 0) {
      return;
    }

    $.ajax({
      url: "/new",
      data: $(this).serialize(),
      dataType: "html",
      success: function(data) {
        $('.container').append(data);
      }

    });

    clearEntries();
    // a event has been created: file creation allowed
    $("#generateButton").removeAttr("disabled");
  });


});



// supplant-function from Douglas Crockford's Remedial JavaScript
String.prototype.supplant = function (o) {
  return this.replace(/{([^{}]*)}/g,
    function (a, b) {
      var r = o[b];
      return typeof r === 'string' || typeof r === 'number' ? r : a;
    }
  );
};


