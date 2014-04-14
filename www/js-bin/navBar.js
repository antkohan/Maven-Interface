//Adds the object to the navigation bar
function updateBar(title, name, sha) {
    var value = $.cookie('navbar');
    if(value !== undefined){
	if (value === ""){
	    value = title.concat(":", name, ":", sha);
	} else {
	    value = value.concat(";", title, ":", name, ":", sha);
	}
    } else {
	value = title.concat(":", name, ":", sha);
    }
    $.cookie('navbar', value, {path : '/'});

    return true;
    
}

//Remove all links in the navigation bar after the one clicked on
function removeExtra(sha){
    var newVal = "";
    var value = $.cookie('navbar');
    if(value !== undefined){
	var objs = value.split(";");
	var i;
	for(i = 0; i < objs.length; i++){
	    if(objs[i].indexOf(sha) < 0){
		newVal = newVal.concat(objs[i], ';');
	    } else {
		newVal = newVal.concat(objs[i], ';');
		break;
	    }
	}
	newVal = newVal.substring(0, newVal.length - 1);
	$.cookie('navbar', newVal, {path : '/'});
    }
    
    return true;
}

function clearBarCookie() {
    $.cookie('navbar', "", {path : '/'});
    return true;
}

function clearBar() {
    $.cookie('navbar', "", {path : '/'});
    $('#navData').remove();
    return true;
}