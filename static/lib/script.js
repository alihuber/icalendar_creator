$(document).ready(function() {

  var language = window.navigator.userLanguage || window.navigator.language;
  var dateformat = '';
  if(language.startsWith('en')) {
    dateformat = "mm/dd/yyyy";
  } else {
    dateformat = "dd.mm.yyyy";
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

  }


  // ajax and UI for add event
  $('#eventForm').submit(function(event){

    event.preventDefault();

    // errors found: don't submit
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

// startswith helper function
if (typeof String.prototype.startsWith != 'function') {
  String.prototype.startsWith = function (str){
    return this.slice(0, str.length) == str;
  };
}
