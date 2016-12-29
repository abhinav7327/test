//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




//Date validation for European style Entry DDMMYYYY and display DD-MMM-YYYY
function dateValidation(inpDate)
{	var mm,dd,yy;
	var dateVal = inpDate;
	var valid="ABCDEFGHIJLMNOPRSTUVY0123456789-";
	
	if	(dateVal.length == 0 ) return "";
	if	(dateVal.length > 11)
		{	alert ("FORMAT should be DDMMYYYY or DDMMYY");
			return "";
		}
		
	for (var i=0; i<dateVal.length; i++)
		{	if	(valid.indexOf(dateVal.charAt(i)) == -1)
				{	alert("INVALID FORMAT. Allowed characters are 'ABCDEFGHIJLMNOPRSTUVY, 0-9 , - '");
					return "";
				}
		}
		
//Check for length of date field = 11 -------------------------------------------------------
	if	(dateVal.length == 11)
		{	if	((isNaN(dateVal)) && (dateVal.charAt(2) == dateVal.charAt(6)))
				{	dd = dateVal.substring(0,2);
					mm = dateVal.substring(3,6);
					switch (mm.toUpperCase())
						{	case "JAN" : mm = "01"; break;
							case "FEB" : mm = "02"; break;
							case "MAR" : mm = "03"; break;
							case "APR" : mm = "04"; break;
							case "MAY" : mm = "05"; break;
							case "JUN" : mm = "06"; break;
							case "JUL" : mm = "07"; break;
							case "AUG" : mm = "08"; break;
							case "SEP" : mm = "09"; break;
							case "OCT" : mm = "10"; break;
							case "NOV" : mm = "11"; break;
							case "DEC" : mm = "12"; break;
							default : mm = "00"; break;
						}
					yy = dateVal.substring(7,11);
				}
			else
				{	alert("INVALID FORMAT. 11 character entry has to be ' dd-mmm-yyyy '");
					return "";
				}
		}

//Check for length of date field = 10 -------------------------------------------------------
	else if	(dateVal.length == 10)
		{	if	(isNaN(dateVal))
				{	if ((dateVal.charAt(2) == "-") && (dateVal.charAt(5) == "-"))
						{	dd = dateVal.substring(0,2);
							mm = dateVal.substring(3,5);
							yy = dateVal.substring(6,10);						
						}
					else
						{	alert("INVALID FORMAT. Allowed separator is ' - '. Month/Date can't be single character");
							return "";
						}
				}
			else
				{	alert("INVALID FORMAT. 10 character entry has to be ' dd-mm-yyyy '");
					return "";
				}
		}

		
//Check for length of date field = 8 --------------------------------------------------------
	else if	(dateVal.length == 8)
		{	if	(isNaN(dateVal))
				{	if ((dateVal.charAt(2) == "-") && (dateVal.charAt(5) == "-"))
						{	dd = dateVal.substring(0,2);
							mm = dateVal.substring(3,5);
							yy = dateVal.substring(6,8);						
						}
					else
						{	alert("INVALID FORMAT. Allowed separator is ' - '. Month/Date can't be single character");
							return "";
						}
				}
			else
				{	dd = dateVal.substring(0,2);
					mm = dateVal.substring(2,4);
					yy = dateVal.substring(4,8);
				}
		}

//Check for length of date field = 6 --------------------------------------------------------
	else if	(dateVal.length == 6)
		{	if	(isNaN(dateVal))
				{	alert("INVALID FORMAT. 6 character entry has to be ' ddmmyy '");
					return "";
				}
			else
				{	dd = dateVal.substring(0,2);
					mm = dateVal.substring(2,4);
					yy = dateVal.substring(4,6);
				}
		}

//Format ddmmyyyy and length of date field = 5 ----------------------------------------------
	else if	(dateVal.length == 5)
		{	if	((isNaN(dateVal)) && (dateVal.charAt(2) == '-'))
				{	dd = dateVal.substring(0,2);
					mm = dateVal.substring(3,5);
					yy = 0;
				}
			else
				{	alert("INVALID FORMAT. 5 character entry has to be ' dd-mm '");
					return "";
				}
		}

//Format ddmmyyyy and length of date field = 4 ----------------------------------------------
	else if	(dateVal.length == 4)
		{	if	(isNaN(dateVal))
				{	alert("INVALID FORMAT. 4 character entry has to be 'ddmm'");
					return "";
				}
			else
				{	dd = dateVal.substring(0,2);
					mm = dateVal.substring(2,4);
					yy = 0;
				}
		}

//If all the above formats with chars -11,10,6,5,4 not true then pop an error message-----------
	else 
		{	alert ("INVALID FORMAT. Allowed no. of characters are 11,10,8,6,5,4");
			return "";
		}

//Individual validation for date,month and year ---------------------------------------------
	if	((isNaN(dd)) || (Math.abs(dd) != dd))
		{	alert(" ' "+ dd + " ' IS AN INVALID DATE");
			return "";
		}
	if	((isNaN(mm)) || (Math.abs(mm) != mm))
		{	alert(" ' "+ mm + " ' IS AN INVALID MONTH");
			return "";
		}	
	if	((isNaN(yy)) || (Math.abs(yy) != yy))
		{	alert(" ' "+ yy + " ' IS AN INVALID YEAR");
			return "";
		}
	//alert(dd + ", " + mm + ", " + yy);
	var retVal1 = validateDMY(dd,mm,yy);
	return retVal1;
}

// This function does the following checks -whether month <12, whether max date value & month combination is valid
// If year is 2 digit it converted into 4 digit.
function validateDMY (D,M,Y)
{
	var validDays;
	var vFlag = 0;		//This flag sets to one if date, month or year is invalid.
	var inpD = D;
	var inpM = M;
	var inpY = Y;
	var objDate = new Date();
	if (inpY == 0) 
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
		{	alert("INVALID FORMAT. Acceptable values for month are 1-12,JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC");
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

// This function populates the date in the display format into the textbox.
function displayDMY(D,M,Y)
{	var dispStr;
	var inpM;
	switch (M)
		{	case "01" : inpM = "JAN"; break;
			case "02" : inpM = "FEB"; break;
			case "03" : inpM = "MAR"; break;
			case "04" : inpM = "APR"; break;
			case "05" : inpM = "MAY"; break;
			case "06" : inpM = "JUN"; break;
			case "07" : inpM = "JUL"; break;
			case "08" : inpM = "AUG"; break;
			case "09" : inpM = "SEP"; break;
			case "10" : inpM = "OCT"; break;
			case "11" : inpM = "NOV"; break;
			case "12" : inpM = "DEC"; break;
			default	  : inpM = "ERR"; break;
		}
		if (Y.length == 2)
			{	if ( Y > 29) Y = Number(Y) + 1900;
				else Y = Number(Y) + 2000;		
			}
		dispStr = D+"-"+inpM+"-"+Y ;
		return dispStr;
}

//Function Checks whether two dates are valid entry
function doTradeDateValueDateCheck(trade_date, value_date)
{
	var strArray;
	var strTradeDate1;
	var strValueDate1;
     	strArray = trade_date.split("-");
	strTradeDate1 = strArray[0] + " " + strArray[1] + " " +  strArray[2];//  Day, Month, Year

	strArray = value_date.split("-");
	strValueDate1 = strArray[0] + " " + strArray[1] + " " +  strArray[2];//  Day, Month, Year

	if((trade_date != "") && (value_date != ""))
	{
     		if (Date.parse(strTradeDate1) > Date.parse(strValueDate1))
		{
			return false;
		}
	}

    	return true;
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

//Function Checks whether from date comes before to date
function checkQueryFromDateToDate(from_date, to_date)
{
	if(doTradeDateValueDateCheck(from_date, to_date) == false)
	{
		return false;
	}
	return true;
}
