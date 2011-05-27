// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function () {
	$('input[type!="hidden"]').first().focus();
});

function addDaysTo(date, nbrDays) {
  date.setDate(date.getDate()+nbrDays);
  return date;
}

function selectDefaultValue(select, value) {
  options = select.attr('options')
  for(i=0; i<options.length;i++)
    if(options[i].value == value) {
      select.attr('selectedIndex', i);
      select.change();
      break;
    }
}

