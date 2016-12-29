//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




//Date validation for Japanese style Entry YYYYMMDD and display YYYYMMDD
function dateValidation(inpDate)
{	var mm,dd,yy;
	var dateVal = inpDate;
	
	if	(dateVal.length == 0 ) return "";
/*	if	((dateVal.length != 8) && (dateVal.length != 6))
		{	alert ("FORMAT should be YYYYMMDD or YYMMDD");
			return "";
		}*/
	if	(dateVal.length != 8)
	{	alert ("FORMAT should be YYYYMMDD");
			return "";
		}
	if	(isNaN(dateVal))
		{	alert("INVALID FORMAT. Non numeric values not accepted");
			return "";
		}
	if	(dateVal.length == 8)
		{
			yy = dateVal.substring(0,4);
			mm = dateVal.substring(4,6);
			dd = dateVal.substring(6,8);
		}
	if	(dateVal.length == 6)
		{
			yy = dateVal.substring(0,2);
			mm = dateVal.substring(2,4);
			dd = dateVal.substring(4,6);
		}
	var retVal1 = validateDMY(dd,mm,yy);
	return retVal1;
}

function validateDMY (D,M,Y)
{	var validDays;
	var vFlag = 0;		//This flag sets to one if date, month or year is invalid.
	var inpD = D;
	var inpM = M;
	var inpY = Y;
	var objDate = new Date();
	if (inpY == "") 
		{	inpY = objDate.getYear();
			alert("No year entered, so taking current year " + inpY + " as default");
		}
    if	( inpM == 1 || inpM == 3 || inpM == 5 || inpM == 7 || inpM == 8 || inpM == 10 || inpM == 12 )	validDays=31;
    else if ( inpM == 4 || inpM == 6 || inpM == 9 || inpM == 11 )	validDays=30;
    else if ( inpM == 2 )
		{	if (isLeapYear(inpY))	validDays=29;
			else	validDays=28;
		}
	else 
		{	alert("INVALID FORMAT. Acceptable values for month are 1-12");
			vFlag = 1;
		}

	if	( inpD > validDays)
		{	alert("INVALID FORMAT. For the entered month, dd should be <= " + validDays);
			vFlag = 1;
		}
	if (vFlag == 0) 
		{	var retVal2 = displayDMY(inpD,inpM,inpY);
			return retVal2;
		}
	else return "";
}

function displayDMY(D,M,Y)
{	var dispStr;
	if (Y.length == 2)
		{	if ( Y > 29) Y = Number(Y) + 1900;
			else Y = Number(Y) + 2000;		
		}
	dispStr = Y+M+D ;
	return dispStr;
}

//Function Checks whether trade date comes before value date
function checkEntryTradeDateValueDate(trade_date, value_date)
{
	if(doTradeDateValueDateCheck(trade_date, value_date) == false)
	{
		alert("VALUE DATE must occur after the TRADE DATE.");
		return false;
	}
	return true;
}

//Function Checks whether two dates are valid entry
function doTradeDateValueDateCheck(trade_date, value_date)
{
	if((trade_date != "") && (value_date != ""))
	{
     		if (trade_date > value_date)
		{
			return false;
		}
	}

    	return true;
}

//Function Checks whether from date comes before to date
function checkQueryFromDateToDate(from_date, to_date)
{
	if(doTradeDateValueDateCheck(from_date, to_date) == false)
	{
		return false;
	}
	return true;
}
