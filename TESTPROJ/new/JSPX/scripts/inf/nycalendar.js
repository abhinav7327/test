//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//************************* Global Vars for Calendar
_monthArray = new Array('January', 'February', 'March', 'April', 'May', 'June','July', 'August', 'September', 'October', 'November', 'December');
_calDate = new Date();
_calCurrentDay = 0;
_containerName ='gCalendar';
_montyhListContainerName ='gMonthList';
_targetField ="";
//_dateFormat ="MON,dd,yy"	;

function calendar(strDate)
{
	// membar variables of calendar object
	this.currentDate = new Date();
	this.currentMonth = 0;
	this.currentMonthName = "";
	this.currentYear = 0;
	this.currentDay = 0;
	this.selectdDate = 0;
	this.renderSkeleton = false;


	//register methods of calendar object
	calendar.prototype.updateYearAndMonthName = updateYearAndMonthName;
	calendar.prototype.getMonthName = getMonthName;
	calendar.prototype.draw = drawCalendar;	
	calendar.prototype.getDaysInMonth =	getDaysInMonth;
	calendar.prototype.debug =	debug;
	calendar.prototype.yearUp =	yearUp1;
	calendar.prototype.yearDn =	yearDn1;
	calendar.prototype.monthChange = monthChange;
	calendar.prototype.rePaint = rePaint;


	
	
	// init with System Date
	this.currentDate = new Date();
	this.currentMonth = this.currentDate.getMonth()+1;
	this.currentMonthName = this.getMonthName();
	this.currentYear = this.currentDate.getFullYear();
	this.currentDay = this.currentDate.getDay();
	this.selectdDate = this.currentDate.getDate();
	this.updateYearAndMonthName();

	if(	document.getElementById('gridContainer').children.length )
	{
		document.getElementById('gridContainer').children[0].removeNode(true)
	}

	
	if(!strDate)
	{

		this.currentDate = new Date();
		this.currentMonth = this.currentDate.getMonth()+1;
		this.currentMonthName = this.getMonthName();
		this.currentYear = this.currentDate.getFullYear();
		this.currentDay = this.currentDate.getDay();
		this.selectdDate = this.currentDate.getDate();
		_calCurrentDay = this.selectdDate
		this.updateYearAndMonthName();

	}
	else
	{
		if(!isNaN(Date.parse(strDate)))
		{
			this.currentDate = new Date(strDate);
			this.currentMonth = this.currentDate.getMonth()+1;
			this.currentMonthName = this.getMonthName(this.currentMonth);
			this.currentYear = this.currentDate.getFullYear();
			this.currentDay = this.currentDate.getDay();
			this.selectdDate = this.currentDate.getDate();
			_calCurrentDay = this.selectdDate
			this.updateYearAndMonthName();
		}
		else
		{
			// reset Date Field in parent Form
			document.getElementById(_targetField).value='';
			this.currentDate = new Date();
			this.currentMonth = this.currentDate.getMonth()+1;
			this.currentMonthName = this.getMonthName();
			this.currentYear = this.currentDate.getFullYear();
			this.currentDay = this.currentDate.getDay();
			this.selectdDate = this.currentDate.getDate();
			_calCurrentDay = this.selectdDate
			this.updateYearAndMonthName();
		}
	}
	this.draw();
//	this.debug();
}


// debug 
function debug()
{
		
	alert("in Draw Method of Calendar Object \n"+ " MonthName : " +this.currentMonthName + "\n "  + "Current Month : "+this.currentMonth + 
	  "\n " +"Current Year : " +this.currentYear + "\n" + "Days In Month : "+ this.getDaysInMonth() + " currentDay :" + this.selectdDate);
}

// updateYearAndMonthName()
function updateYearAndMonthName()
{
	document.getElementById('calCurrentMonth').value = this.currentMonthName;
	document.getElementById('calCurrentYear').value = this.currentYear;
}
//setCurrentMonth(monthNumber)
function setCurrentMonth(monthNumber)
{
	if(parseInt(monthNumber)!='NaN')
	{
		return monthNumber;
	}
	else
	{
		return -1;
	}
}

// getMonthName method to get Month Name by Month number

function getMonthName()
{
	if(!isNaN(parseInt(this.currentMonth)))
	{
		return _monthArray[this.currentMonth-1];
	}
	else
	{
		return "Error Month number";
	}
}


function showMonthList(event)
{
	document.getElementById(_montyhListContainerName).style.display="block";
	document.getElementById(_montyhListContainerName).style.posLeft=window.event.x;
	document.getElementById(_montyhListContainerName).style.posTop=window.event.y;
	//alert(document.getElementById('gMonthList').innerHTML);

	//document.getElementById('monthList').focus();
}
function yearUp()
{
	
	var oCalCurrentMonth = document.getElementById('calCurrentMonth');
	var oCalCurrentYear = document.getElementById('calCurrentYear');
	oCalCurrentYear.value = parseInt(oCalCurrentYear.value)+1;

	if(	document.getElementById('gridContainer').children.length )
	{
		document.getElementById('gridContainer').children[0].removeNode(true)
	}
	
	//var strDate = oCalCurrentMonth.value + " 1," + parseInt(oCalCurrentYear.value);
	var tmpDay= (_calCurrentDay >0 && _calCurrentDay < 31)? _calCurrentDay+"," : " 1," ;
	var strDate = oCalCurrentMonth.value + tmpDay + parseInt(oCalCurrentYear.value);
	oCal = new calendar(strDate);
}
function yearDown()
{
	var oCalCurrentMonth = document.getElementById('calCurrentMonth');
	var oCalCurrentYear = document.getElementById('calCurrentYear');
	oCalCurrentYear.value = parseInt(oCalCurrentYear.value)-1;

	if(	document.getElementById('gridContainer').children.length )
	{
		document.getElementById('gridContainer').children[0].removeNode(true)
	}
	
	//var strDate = oCalCurrentMonth.value + " 1," + parseInt(oCalCurrentYear.value);
	var tmpDay= (_calCurrentDay >0 && _calCurrentDay < 31)? _calCurrentDay+"," : " 1," ;
	var strDate = oCalCurrentMonth.value + tmpDay + parseInt(oCalCurrentYear.value);

	oCal = new calendar(strDate);
}
function setCurrentMonth(strMonthName)
{
	var oCalCurrentMonth = document.getElementById('calCurrentMonth');
	var oCalCurrentYear = document.getElementById('calCurrentYear');

	oCalCurrentMonth.value = strMonthName;
	//document.getElementById('gridContainer').removeNode(true);
	
	if(	document.getElementById('gridContainer').children.length )
	{
		document.getElementById('gridContainer').children[0].removeNode(true)
	}

	document.getElementById(_montyhListContainerName).style.display='none';
	//var strDate = strMonthName + " 1," + parseInt(oCalCurrentYear.value);
	var tmpDay= (_calCurrentDay >0 && _calCurrentDay < 31)? _calCurrentDay+"," : " 1," ;
	var strDate = oCalCurrentMonth.value + tmpDay + parseInt(oCalCurrentYear.value);
//alert(_calCurrentDay);
	oCal = new calendar(strDate);
}
function closeMonthList()
{
	document.getElementById(_montyhListContainerName).style.display='none';
}


////**********************
// GET NUMBER OF DAYS IN MONTH
function getDaysInMonth()  {

    var days = 0 ;
    var month = parseInt(this.currentMonth);
    var year  = parseInt(this.currentYear);
    // RETURN 31 DAYS
    if (month==1 || month==3 || month==5 || month==7 || month==8 ||
        month==10 || month==12)  {
        days=31;
    }
    // RETURN 30 DAYS
    else if (month==4 || month==6 || month==9 || month==11) {
        days=30;
    }
    // RETURN 29 DAYS
    else if (month==2)  {
        if (isLeapYear(year)) {
            days=29;
        }
        // RETURN 28 DAYS
        else {
            days=28;
        }
    }
    return (days);
}


// CHECK TO SEE IF YEAR IS A LEAP YEAR
function isLeapYear (Year) {

    if (((Year % 4)==0) && ((Year % 100)!=0) || ((Year % 400)==0)) {
        return (true);
    }
    else {
        return (false);
    }
}


// Create WeekDayList 

function buildWeekDayHeader()
{
	var weekDayHeader = "<tr><td  align=\"center\" class=\"dayName\">Sa</td><td  align=\"center\" class=\"dayName\">Mo</td><td  align=\"center\" class=\"dayName\">Tu</td><td  align=\"center\" class=\"dayName\">We</td><td  align=\"center\" class=\"dayName\">Th</td><td  align=\"center\" class=\"dayName\">Fr</td><td  align=\"center\" class=\"dayName\">Su</td></tr>";
	return weekDayHeader;
}

function buildCalendarTable()
{
	var oTbl = document.createElement("TABLE");
	oTbl.cellSpacing=1;
	oTbl.cellPadding=0;
	oTbl.id="calGrid";
	return oTbl;
}


// CREATE THE BOTTOM CALENDAR FRAME 
// (THE MONTHLY CALENDAR)
function drawCalendar() 
{       

    // GET MONTH, AND YEAR FROM GLOBAL CALENDAR DATE
    month   = this.currentMonth-1;
    year    = this.currentYear;
	
	//this.debug();

	// hide  monthList unconditionally
	closeMonthList();
	
	// build Table Object 
	var oTbl = document.createElement('TABLE');
	oTbl.cellPadding=0;
	oTbl.cellSpacing=1;
	oTbl.border=0
	oTbl.bgColor="#808080";
	var wNameRow = oTbl.insertRow();
	
	// Day Name header array
	var dayName = new Array('Su','Mo','Tu','We','Th','Fr','Sa');

	// build weekDayName header row with a loop 
	for(i=0;i<7;i++)
	{
		var oWeekDayTD = document.createElement('TD');
		oWeekDayTD.className='dayName';
		oWeekDayTD.innerText=dayName[i]
		wNameRow.appendChild(oWeekDayTD);
	}
	// alert(oTbl.innerHTML);

	day     = this.currentDay;

    var i   = 0;

    // DETERMINE THE NUMBER OF DAYS IN THE CURRENT MONTH
    var days = this.getDaysInMonth();
    // IF GLOBAL DAY VALUE IS > THAN DAYS IN MONTH, HIGHLIGHT LAST DAY IN MONTH
    if (day > days) {
        day = days;
    }
    // DETERMINE WHAT DAY OF THE WEEK THE CALENDAR STARTS ON
    var firstOfMonth = new Date (year, month, 1);

    // GET THE DAY OF THE WEEK THE FIRST DAY OF THE MONTH FALLS ON
    var startingPos  = firstOfMonth.getDay();
    days += startingPos;

    // KEEP TRACK OF THE COLUMNS, START A NEW ROW AFTER EVERY 7 COLUMNS
    var columnCount = 0;

	// Add a new Row 
	var oRow= oTbl.insertRow();


    // MAKE BEGINNING NON-DATE CELLS BLANK	
    for (i = 0; i < startingPos; i++) 
	{

        oEmptyTD = document.createElement('TD');
		oEmptyTD.className='day';
		oEmptyTD.innerText="";
		oRow.appendChild(oEmptyTD);
	columnCount++;
    }
	//alert(oTbl.innerHTML);		
	

	 // SET VALUES FOR DAYS OF THE MONTH
    var currentDay = 0;
    var dayType    = "weekday";

    // DATE CELLS CONTAIN A NUMBER
    for (i = startingPos; i < days; i++) 
	{

	var paddingChar = "&nbsp;";

        // ADJUST SPACING SO THAT ALL LINKS HAVE RELATIVELY EQUAL WIDTHS
        if (i-startingPos+1 < 10) {
            padding = "&nbsp;&nbsp;";
        }
        else {
            padding = "&nbsp;";
        }

        // GET THE DAY CURRENTLY BEING WRITTEN
        currentDay = i-startingPos+1;

        // SET THE TYPE OF DAY, THE focusDay GENERALLY APPEARS AS A DIFFERENT COLOR
        if (currentDay == day) {
            dayType = "focusDay";
        }
        else {
            dayType = "weekDay";
        }

        // ADD THE DAY TO THE CALENDAR GRID and render the cell
     	   
			var oDayTD = document.createElement('TD');
			if(currentDay == _calCurrentDay)
			{
				oDayTD.className="cday";
			}
			else
			{
				oDayTD.className="day";
			}
			//oDayTD.innerText=currentDay;
			// add day with link
			var currentDateString = this.currentYear +""+( (this.currentMonth.toString().length<2)? "0"+this.currentMonth : this.currentMonth )+""+ ( (currentDay.toString().length<2) ? "0"+currentDay : currentDay );
			//alert(formatDate(currentDateString,_dateFormat));
			
			//currentDateString = formatDate(currentDateString,_dateFormat);

			var dayStr= "<a href=\"javascript:void(0)\" onclick=\"setDate('"+ currentDateString + "')\" class='lnk'>" + currentDay + "</a>";
			oDayTD.innerHTML= dayStr;
			oRow.appendChild(oDayTD);
       
		columnCount++;

        // START A NEW ROW WHEN NECESSARY
        if (columnCount % 7 == 0) {
            //calDoc += "</TR><TR>";
			oRow= oTbl.insertRow();
        }
    }// end for

	//alert(oTbl.innerHTML);		


	// rest of Empty cell
	 for (i=days; i<42; i++)  
	 {

        oEmptyTD = document.createElement('TD');
		oEmptyTD.className='day';
		oEmptyTD.innerText="";
		oRow.appendChild(oEmptyTD);

		columnCount++;

        // START A NEW ROW WHEN NECESSARY
        if (columnCount % 7 == 0) {
            //calDoc += "</TR>";
            if (i<41) {
                //calDoc += "<TR>";
				oRow= oTbl.insertRow();
            }
        }
    }

	
	
	document.getElementById('gridContainer').appendChild(oTbl);
	//alert(document.getElementById('gridContainer').innerHTML);	
}


function closeCalendar()
{
	// close calendar
	objCal= document.getElementById('gCalendar');
	if(objCal)
	{
		objCal.style.display="none";
	}
	closeMonthList();
	menuFocusHookComboShow();

}

function showCalendar(objName)
{
		
	oFld= document.getElementById(objName);
	oFldVal="";
	if(oFld)
	{
		oFldVal=oFld.value;
		_targetField = objName;
	}

	// show calendar
	objCal= document.getElementById('gCalendar');
	if(!objCal.children.length)
	{
		initCalendar1();
	}
	if(objCal)
	{
		//objCal.style.posLeft = window.event.x;
		//objCal.style.posTop = window.event.y;
		var scrollTop = document.body.scrollTop;
		var scrollLeft = document.body.scrollLeft;
		
		// added for if user resize the window then adjust display co-ordinate acordingly
		if( (window.event.x + 150) > document.body.clientWidth   )
		{
			objCal.style.posLeft = window.event.x - ( (window.event.x + 150) - (document.body.clientWidth));
			objCal.style.posTop = (window.event.y+ scrollTop);
		}
		else
		{
			objCal.style.posLeft = (window.event.x + scrollLeft);
			objCal.style.posTop = (window.event.y+ scrollTop);
		}
		
		// hide all combo on page
		menuFocusHookComboHide();
		objCal.style.display="block";	
	}
	//create calendar object
	var existingDateString = parseDateFromFieldValue(oFldVal);
	var oCal=new Object();
	if(!isNaN(Date.parse(existingDateString)))
	{
		oCal= new calendar(existingDateString);
	}
	else
	{
		oCal= new calendar();
	}
}


function initCalendar1()
{
	var oCalContainer = document.getElementById(_containerName);

	// create titlebar of calendar with close button
	var oTitleDiv=document.createElement('DIV');
	oTitleDiv.className="Title";
	oTitleDiv.innerHTML= "<a href=\"javascript:void(0)\" class=\"lnk\" onclick=\"closeCalendar()\"><img src=\"" + mCalClose.src + "\" border=\"0\"><a/>";

	//attach titlebar with calendar container
	oCalContainer.appendChild(oTitleDiv);

	var oSkeletonDiv=document.createElement('DIV');
	
	var strHTML = "";
		strHTML+="<table border=\"0\"  cellpadding=\"0\" cellspacing=\"1\">\n";
		strHTML+="<tr>\n";
		strHTML+="<td class=\"calTop\">\n";
		strHTML+="<table border=\"0\"  cellpadding=\"0\" cellspacing=\"0\">\n";
		strHTML+="<tr>\n";
		strHTML+="<td id=\"aMonthList\">\n";
		strHTML+="<input type=\text\ name=\"calCurrentMonth\" value=\"September\" HIDEFOCUS class=\"calTextbox\" style=\"width:65px\">\n";
		strHTML+="</td>\n";
		strHTML+="<td class=\"arrow\"><a href=\"javascript:void(0)\" onclick=\"showMonthList()\" ><img src=\"" + mCalArrow.src + "\" border=\"0\"></a></td>\n";
		strHTML+="<td><input type=\"text\" name=\"calCurrentYear\" value=\"2004\" class=\"calTextbox\"  style=\"width:35px\"></td>\n";
		strHTML+="<td class=\"arrow\" width=\"10\"><a href=\"javascript:void(0)\" onclick=\"yearUp()\"><img src=\""+ mCalSpinnerUp.src + "\" border=\"0\"></a><a href=\"javascript:void(0)\" onclick=\"yearDown()\"><img src=\"" + mCalSpinnerDn.src + "\" border=\"0\"></a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="</table>\n";
		strHTML+="</td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr>\n";
		strHTML+="<td align=\"center\" class=\"gridContainer\" id=\"gridContainer\">\n";
		strHTML+="</td>\n";
		strHTML+="</tr>\n";
		strHTML+="</table>\n";
		
	oSkeletonDiv.innerHTML=strHTML;
	oCalContainer.appendChild(oSkeletonDiv);
	buildMonthList();
}

function buildMonthList()
{
	var oMonthListContainer = document.getElementById(_montyhListContainerName);
	//var oMonthListContainer = document.getElementById(_containerName);

	var oMonthListDiv=document.createElement('DIV');
	oMonthListDiv.id='monthList';
	oMonthListDiv.className='monthList';
	oMonthListDiv.align="center";
	oMonthListDiv.vAlign="center";
	oMonthListDiv.style.position="relative";
	oMonthListDiv.style.display="block";
	oMonthListDiv.style.height=document.getElementById(_containerName).style.height;
	oMonthListDiv.style.overflowY="scroll";
	oMonthListDiv.style.overflowX="scroll";
	oMonthListDiv.style.zIndex=999;


	var strHTML = "";
		
		//strHTML+="<div id=\"monthList\" class=\"monthlist\" style=\"display:none;position:absolute\">\n";
		strHTML+="<table cellpadding=\"0\" cellspacing=\"1\" border=\"0\">\n";
		strHTML+="<tr class=\"Title\">\n";
		strHTML+="<td align=\"right\"><a href=\"javascript:void(0)\" class=\"lnk\" onclick=\"closeMonthList()\"><img src=\"../images/btnClose.gif\" border=\"0\"><a/></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"even\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('January')\">January</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"odd\">\n";
	
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('February')\">February</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"even\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('March')\">March</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"odd\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('April')\">April</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"even\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('May')\">May</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"odd\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('June')\">June</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"even\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('July')\">July</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"odd\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('August')\">August</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"even\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('September')\">September</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"odd\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('October')\">October</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"even\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('November')\">November</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="<tr class=\"odd\">\n";
		strHTML+="<td class=\"monthName\"><a href=\"javascript:void(0)\" id=\"calcmlist\" class=\"lnk\" onclick=\"setCurrentMonth('December')\">December</a></td>\n";
		strHTML+="</tr>\n";
		strHTML+="</table>\n";
		//strHTML+="</div>\n";
	
	//attach titlebar with calendar container
	oMonthListDiv.innerHTML=strHTML;
	oMonthListContainer.appendChild(oMonthListDiv);
}

function yearUp1()
{

}
function yearDn1()
{

}
function monthChange()
{

}
function rePaint()
{

}

function setDate(dateStr)
{
	/*
	if(document.getElementById(_montyhListContainerName).style.display=="block")
	{
		alert("Please Select A Month Please or Close the Month List window");
		return;
	}
	else
	{
		*/
		
		//alert(dateStr);
		var formatedDateString = formatDate(dateStr,_dateFormat);
		//document.getElementById(_targetField).value= dateStr;
		document.getElementById(_targetField).value= formatedDateString;
		menuFocusHookComboShow();
		objCal= document.getElementById('gCalendar');
		objCal= document.getElementById('gCalendar');
		document.getElementById(_montyhListContainerName).style.display="none";
		objCal.style.display="none";
		document.getElementById(_targetField).focus();
	//}
}

function parseDateFromFieldValue(oFldVal)
{
var retDateString ="";
	// if valid Integer Value
	if(!isNaN(parseInt(oFldVal)) )
	{
		// if legth of the value is less or equal to 8
		if(oFldVal.length<=10)
		{
			/*var tempYearString  = oFldVal.substr(0,4);
			var tempMonthString = oFldVal.substr(4,2);
			var tempDayString = oFldVal.substr(6,2);
			//alert(tempYearString + " "+ tempMonthString + " "+  tempDayString);
			*/

			var formatLength = _dateFormat.length;
			var posYYYY = _dateFormat.indexOf("yyyy");
			var posYY = _dateFormat.indexOf("yy");
			var posMM = _dateFormat.indexOf("MM");
			var posDD = _dateFormat.indexOf("dd");
			var posMON = _dateFormat.indexOf('MON');

			var valYYYY = oFldVal.substr(posYYYY,4);
			var valYY =  oFldVal.substr(posYY,2);
			var valDD = oFldVal.substr(posDD,2);
			var valMM = oFldVal.substr(posMM,2);
			retDateString = _monthArray[parseInt(valMM-1)] + valDD + ","+ valYYYY;
		}
	}
	
	//var valMon
	//alert("valYYYY :" + valYYYY +"\n " + "valDD : "+ valDD + "\n"+"valMM :" + valMM);
	//_dateFormat
	//alert("original value fromfield : " +oFldVal + "ret Value :" + retDateString +" >>" +Date.parse(retDateString));
	return retDateString;
}


function addZero(vNumber){ 
    return ((vNumber < 10) ? "0" : "") + vNumber 
  } 
        
  function formatDate(dateString, vFormat){ 
	//vDate= new Date(parseDateFromFieldValue(dateString));
	
	vDate= new Date(parseDateDefault(dateString));
    var vDay              = addZero(vDate.getDate()); 
    var vMonth            = addZero(vDate.getMonth()+1); 
    var vYearLong         = addZero(vDate.getFullYear()); 
    var vYearShort        = addZero(vDate.getFullYear().toString().substring(3,4)); 
    var vYear             = (vFormat.indexOf("yyyy")>-1?vYearLong:vYearShort) 
    var vHour             = addZero(vDate.getHours()); 
    var vMinute           = addZero(vDate.getMinutes()); 
    var vSecond           = addZero(vDate.getSeconds()); 
    var vDateString       = vFormat.replace(/dd/g, vDay).replace(/MM/g, vMonth).replace(/y{1,4}/g, vYear) 
    vDateString           = vDateString.replace(/hh/g, vHour).replace(/mm/g, vMinute).replace(/ss/g, vSecond) 


	//alert(monthName(vMonth) + vMonth);
    //alert(jsReplace(vDateString,'Mon',_monthArray[parseInt(vMonth)]));
	//vDateString = jsReplace(vDateString,'Month',_monthArray[parseInt(vMonth)]);
	vDateString = jsReplace(vDateString,'Month',monthName(vMonth));

	// replace Mon with Abbrv of 3 letter of Month in initial Caps ( Jan, Feb ...)
	var MonVal = monthName(vMonth).substr(0,3);
	vDateString = jsReplace(vDateString,'Mon', MonVal);

	// replace mon with Abbrv of 3 letter of Month in lower case ( jan, feb ...)
	var monVal = monthName(vMonth).substr(0,3).toLowerCase();
	vDateString = jsReplace(vDateString,'mon', monVal);

	// replace mon with Abbrv of 3 letter of Month in upper case ( JAN, FEB ...)
	var MONVal = monthName(vMonth).substr(0,3).toUpperCase();
	vDateString = jsReplace(vDateString,'MON', MONVal);

    return vDateString 
  } 

// parse date asuming date string in yyyyMMdd format
function parseDateDefault(dateStringDefault)
{
var retDateString ="";
	// if valid Integer Value
	if(!isNaN(parseInt(dateStringDefault)) )
	{
		// if legth of the value is less or equal to 8
		if(dateStringDefault.length<=8)
		{
			var tempYearString  = dateStringDefault.substr(0,4);
			var tempMonthString = dateStringDefault.substr(4,2);
			var tempDayString = dateStringDefault.substr(6,2);
			//alert(tempYearString + " "+ tempMonthString + " "+  tempDayString);				
			retDateString = _monthArray[parseInt(tempMonthString-1)] + tempDayString + ","+ tempYearString;
		}
	}
	return retDateString;
}

// REPLACE ALL INSTANCES OF find WITH replace
// inString: the string you want to convert
// find:     the value to search for
// replace:  the value to substitute
//
// usage:    jsReplace(inString, find, replace);
// example:  jsReplace("To be or not to be", "be", "ski");
//           result: "To ski or not to ski"
//
function jsReplace(inString, find, replace) {

    var outString = "";

    if (!inString) {
        return "";
    }

    // REPLACE ALL INSTANCES OF find WITH replace
    if (inString.indexOf(find) != -1) {
        // SEPARATE THE STRING INTO AN ARRAY OF STRINGS USING THE VALUE IN find
        t = inString.split(find);

        // JOIN ALL ELEMENTS OF THE ARRAY, SEPARATED BY THE VALUE IN replace
        return (t.join(replace));
    }
    else {
        return inString;
    }
}
// to deriver the monthName from _monthArray 
// Asumption : monthNumber is allways 1 based ( 1-12 ) 
function monthName(monthNumber)
{
	if(!isNaN(parseInt(monthNumber)))
	{
		return _monthArray[monthNumber-1];
	}
	else
	{
		return "Error Month number";
	}
}