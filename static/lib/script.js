$(document).ready(function() {

  var language = window.navigator.userLanguage || window.navigator.language;
  var dateformat = "dd.mm.yyyy"
  if(language.startsWith("en-US")) {
    language = "en-US"
    dateformat = "mm/dd/yyyy";
  }
  // sometimes de-DE
  // if(language.startsWith("de")) {
  //   language = "de";
  // }
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
        // No errors on repitition or alarm forms
        if(($(this).attr('id') == "inputRepFreq") || ($(this).attr('id') == "inputInterval")) {
          $(this).closest('.control-group').removeClass('error');
          errorCount -= 1;
        }
        if(($(this).attr('id') == "inputAlarmTimeValue") || ($(this).attr('id') == "inputAlarmTimeUnit")) {
          $(this).closest('.control-group').removeClass('error');
          errorCount -= 1;
        }
      }
    });


    checkDates();
    checkTimes();
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

    if(language == "en-US") {
      var compDate1 = new Date(date1);
      var compDate2 = new Date(date2);
      if(compDate2 < compDate1) {
        $("[id=inputEndDate]").closest('.control-group').addClass('error');
        errorCount += 1;
      }

    } else  {
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
        errorCount += 1;
      }
    }

  }



  function checkTimes() {
    // the event is a one-day event
    var date1 = $("[id=inputStartDate]").attr('value');
    var date2 = $("[id=inputEndDate]").attr('value');

    // it is possible to enter times and then choose all-day
    if(date1 == date2 && !$("#wholeDayCheckbox").prop('checked')) {
      var time1 = $("[id=inputStartTime]").attr('value');
      var time2 = $("[id=inputEndTime]").attr('value');

      var compDate1 = Date.parse("01/01/2013 " + time1 + ":00");
      var compDate2 = Date.parse("01/01/2013 " + time2 + ":00");

      if(compDate2 < compDate1) {
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


// startsWith
if (typeof String.prototype.startsWith != 'function') {
  String.prototype.startsWith = function (str){
    return this.slice(0, str.length) == str;
  };
}
