//Fixes a bug with tablesorter pager
jQuery.browser = {};
(function () {
    jQuery.browser.msie = false;
    jQuery.browser.version = 0;
    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
        jQuery.browser.msie = true;
        jQuery.browser.version = RegExp.$1;
    }
})();

//Tablesorter custom sorter for dates
$.tablesorter.addParser({
    id: "customDate",
    is: function(s) {
	return /\d{1,4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}-\d+/.test(s);
  },
    format: function(s) {
        s = s.replace(/\-/g," ");
        s = s.replace(/:/g," ");
        s = s.replace(/\./g," ");
        s = s.split(" ");
        return $.tablesorter.formatFloat(new Date(s[0], s[1]-1, s[2], s[3], s[4], s[5]).getTime()+parseInt(s[6]));
    },
    type: "numeric"
});

$(document).ready(function() {
    $('#methList')
        .tablesorter({headers:{3:{sorter:'customDate'}}})
	.tablesorterPager({container: $("#methPager")});
    $('#attrList')
        .tablesorter({headers:{2:{sorter:'customDate'}}})
	.tablesorterPager({container: $("#attrPager")});
    $('#classList')
        .tablesorter({headers:{3:{sorter:'customDate'}}})
	.tablesorterPager({container: $("#classPager")});
    $('#fileList')
        .tablesorter({headers:{2:{sorter:'customDate'}}})
	.tablesorterPager({container: $("#filePager")});
    $('#containerList')
        .tablesorter()
        .tablesorterPager({container: $("#containerPager")});
    $('#projectList')
        .tablesorter()
        .tablesorterPager({container: $("#projectPager")});
    $("#tabs").tabs();
});
