//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
function checkDate(dt) {
	if(dt.value == ""){
		return true;
	}
	if (isDateCustom(dt.value)==false){
		return false;
	}
    return true;
}
function getMonth(val) {
    var monthArray = new Array("JAN","FEB","MAR","APR","MAY","JUN",
    "JUL","AUG","SEP","OCT","NOV","DEC");
    for (var i=0; i<monthArray.length; i++) {
                if (monthArray[i] == val.toUpperCase()) {
                return(i+1);
                } 
    }
                return(-1);
}
function isInteger(s){
	var i;
    for (i = 0; i < s.length; i++){   
        // Check that current character is number.
        var c = s.charAt(i);
        if (((c < "0") || (c > "9"))) return false;
    }
    // All characters are numbers.
    return true;
}
function stripCharsInBag(s, bag){
	var i;
    var returnString = "";
    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.
    for (i = 0; i < s.length; i++){   
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}
function daysInFebruary (year){
	// February has 29 days in any year evenly divisible by four,
    // EXCEPT for centurial years which are not also divisible by 400.
    return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
}
function DaysArray(n) {
	for (var i = 1; i <= n; i++) {
		this[i] = 31;
		if (i==4 || i==6 || i==9 || i==11) {this[i] = 30;}
		if (i==2) {this[i] = 29;}
   } 
   return this
}

/*
* Compare between two string.
*/
function equalsIgnoreCase(str1, str2){
	if(str1 === str2){
		return true;
	}
	
	if(str1){
		str1 = str1.toUpperCase();
	}
	
	if(str2){
		str2 = str2.toUpperCase();
	}
	
	return (str1 === str2);
}

function containsIgnoreCase(source, target){
    if(!source || !target){
		return false;
	}
	
	if(source === target){
		return true;
	}
	
	if(source){
		source = source.toUpperCase();
	}
	
	if(target){
		target = target.toUpperCase();
	}
	
	return source.indexOf(target)==-1 ? false : true;
}

/*
* This API validates the date and returns true/false accordingly
* This does not display any message using javascript alert function.
*/
function isDateCustom(dtStr){
	var dateFrmt = xenos$Cache.get('globalPrefs')['mappedUiDisplayDateFormat'];
	//var dateFrmt = 'yymmdd';
	//alert("date format "+ dateFrmt);
	var dateFormat = null;
	var daysInMonth = DaysArray(12);
	var minYear=1900;
	var maxYear=9999;
	var success = true; 
	var dtCh= "/";
	var pos1= null;
	var pos2 = null;
	var strMonth = null;
	var strDay= null;
	var strYear= null;
	var isDtch=false;
	
		
	if(containsIgnoreCase(dtStr, "$today+") || 
		containsIgnoreCase(dtStr, "$appDate+") || 
		containsIgnoreCase(dtStr, "$sysDate+") || 
		containsIgnoreCase(dtStr, "$today-") || 
		containsIgnoreCase(dtStr, "$appDate-") || 
		containsIgnoreCase(dtStr,  "$sysDate-")){
        if(dtStr.indexOf("+")>=0){
            var numberVal = dtStr.substring(dtStr.indexOf("+")+1);
            
            if(isNaN(numberVal) || numberVal==''){
                        success = false;
            }else{
                        success = true;
            }
        }
        if(dtStr.indexOf("-")>=0){
            var numberVal = dtStr.substring(dtStr.indexOf("-")+1);
            if(isNaN(numberVal) || numberVal==''){
                        success = false;
            }else{
                        success = true;
            }
        }
    }else if(equalsIgnoreCase(dtStr ,'$today') || equalsIgnoreCase(dtStr , '$sysDate') || equalsIgnoreCase(dtStr , '$appDate')){
			success = true;
	}else if(dateFrmt == 'mm/dd/yy'){
		dateFormat = 'MM/DD/YYYY';
    	pos1=dtStr.indexOf(dtCh);
 		pos2=dtStr.indexOf(dtCh,pos1+1);
 		strMonth=dtStr.substring(0,pos1);
 		strDay=dtStr.substring(pos1+1,pos2);
 		strYear=dtStr.substring(pos2+1);
 		strYr=strYear;
 		isDtch=true;
 		if (pos1==-1 || pos2==-1){
 			success = false;
 		}
 	}else if(dateFrmt == 'yy/dd/mm'){
 		dateFormat = 'YYYY/DD/MM';
 		pos1=dtStr.indexOf(dtCh);
 		pos2=dtStr.indexOf(dtCh,pos1+1);
 		strYear=dtStr.substring(0,pos1);
 		strDay=dtStr.substring(pos1+1,pos2);
 		strMonth=dtStr.substring(pos2+1);
 		strYr=strYear;
 		isDtch=true;
 		if (pos1==-1 || pos2==-1){
 			success = false;
 		}
 	}else if(dateFrmt == 'dd/mm/yy'){
 		dateFormat = 'DD/MM/YYYY';
 		pos1=dtStr.indexOf(dtCh);
 		pos2=dtStr.indexOf(dtCh,pos1+1);
 		strDay=dtStr.substring(0,pos1);
 		strMonth=dtStr.substring(pos1+1,pos2);
 		strYear=dtStr.substring(pos2+1);
 		strYr=strYear;
 		isDtch=true;
 		if (pos1==-1 || pos2==-1){
 			success = false;
 		}
 	}else if(dateFrmt == 'yy/mm/dd'){
 		dateFormat = 'YYYY/MM/DD';
 		pos1=dtStr.indexOf(dtCh);
 		pos2=dtStr.indexOf(dtCh,pos1+1);
 		strYear=dtStr.substring(0,pos1);
 		strMonth=dtStr.substring(pos1+1,pos2);
 		strDay=dtStr.substring(pos2+1);
 		strYr=strYear;
 		isDtch=true;
 		if (pos1==-1 || pos2==-1){
 			success = false;
 		}
 	}else if(dateFrmt == 'dd-M-yy'){
 		dateFormat = 'DD-MON-YYYY';
 		dtCh= "-";
 		pos1=dtStr.indexOf(dtCh);
 		pos2=dtStr.indexOf(dtCh,pos1+1);
 		strDay=dtStr.substring(0,pos1);
 		strMonth=getMonth(dtStr.substring(pos1+1,pos2)).toString();
 		strYear=dtStr.substring(pos2+1);
 		strYr=strYear;
 		isDtch=false;
 		if (pos1==-1 || pos2==-1){
 			success = false;
 		}
 	}else if(dateFrmt == 'yymmdd'){
 		dateFormat = 'YYYYMMDD';
 		strMonth=dtStr.substring(4,6);
 		strDay=dtStr.substring(6);
 		strYear=dtStr.substring(0,4);
 		strYr=strYear;
 		if (isInteger(dtStr)==false){
 			success = false;
 		}
 	}
	if(isDtch && success && dtStr.indexOf("$")!= 0){
 		if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
 			success = false;
 		}
	}
	if(success && dtStr.indexOf("$")!= 0){
		if (strDay.charAt(0)=="0" && strDay.length>1){
			strDay=strDay.substring(1);
		}
		if (strMonth.charAt(0)=="0" && strMonth.length>1){
			strMonth=strMonth.substring(1);
		}
		for (var i = 1; i <= 3; i++) {
			if (strYr.charAt(0)=="0" && strYr.length>1){
				strYr=strYr.substring(1);
			}
		}
		month=parseInt(strMonth);
		day=parseInt(strDay);
		year=parseInt(strYr);
		//alert(day + " " + month + " " +year);
		if (strMonth.length<1 || month<1 || month>12 || isNaN(month)){
			success = false;
		}else if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month] || isNaN(day)){
			success = false;
		}else if (strYear.length != 4 || year==0 || year<minYear || year>maxYear || isNaN(year)){
			success = false;
		}
	}
      return(success);
}
/*
* This API validates the date range returns true/false accordingly
*/
function isValidDateRange(fromDate, toDate){
	var success = true;
	
	if((fromDate != null && fromDate.length > 0) && (toDate != null && toDate.length > 0)){
		if (fromDate > toDate) {
			success = false;
		}
	}
	
	return success;
}