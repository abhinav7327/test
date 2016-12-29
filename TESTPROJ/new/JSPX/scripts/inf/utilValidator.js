//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $



 
 
/**  
 * This java script file contains some validation routines, to be used in
 * different js functions for common validations accross different Xenos modules.
 *
 * Usage: 
 * To check a null/empty value
 * ---------------------------
 *	var validationMessage = "";
 * 	validationMessage = VALIDATOR.checkForNull( document.forms[0].accountNo,"Account No");
 *	if ( validationMessage != "")
 *	{
 *		alert(validationMessage);
 *		return false;
 *	}
 *
 *
 *
 * @version
 */

var EMPTY_STRING = "";

function validation()
{
	/*
	NULL/EMPTY String Validation routine for all types of variable/object (checkForNull)
	It checks whether
		a) Passed parameter is a valid object or not
		b) Checking for null
	return : Validation message if occured else Empty String
	*/
	this.checkForNull = function(ObjectName, ObjectDisplayName)
	{

		if (  this.isObject(ObjectName) == false )
			return "VALIDATOR:checkForNull() : Undefined parameter for "+ ObjectDisplayName +"\n" ;

		objValue = this.trim(ObjectName.value); 
		var retMessage = "";

		if ( this.isNullValue(objValue) )
		{
			retMessage ="o  " + ObjectDisplayName +" can not be empty\n" ;
			return retMessage;
		}
		return retMessage;
	}// Check for null value.


	/*
	Validation routine for all type of Float value (isFloat)
	It checks whether
		a) Passed parameter is a valid object or not
		b) Checking for null
		c) Checking for numeric/non-numeric value
	return : Validation message if occured else Empty String
	*/
	/*public String*/this.isFloat = function(ObjectName, ObjectDisplayName)
	{

		if (  this.isObject(ObjectName) == false )
			return "VALIDATOR:isFloat() : Undefined parameter for "+ ObjectDisplayName +"\n" ;

		objValue = this.trim(ObjectName.value);
		var retMessage = "";

		if ( this.isNullValue(objValue) )
		{
			retMessage ="o  " + ObjectDisplayName +" can not be empty\n" ;
			return retMessage;
		}

		objValue = this.replaceAll(objValue, ",","") ; //objValue.replace(",", "");

		objValueFloat = parseFloat(objValue);
		if ( isNaN(objValue) )
		{
			retMessage ="o  " + ObjectDisplayName +" must be Numeric\n" ;
			return retMessage;
		}
		return retMessage;
	}//isFloat

	/*
	Validation routine for all type of Float value (isPositiveFloat)
	It checks whether
		a) Passed parameter is a valid object or not
		b) Checking for null
		c) Checking for numeric/non-numeric value
		d) Checking for Negative value
	return : Validation message if occured else Empty String
	*/
	/*public String*/this.isPositiveFloat = function(ObjectName, ObjectDisplayName)
	{
		if (  this.isObject(ObjectName) == false )
			return "VALIDATOR:isPositiveFloat() : Undefined parameter for "+ ObjectDisplayName +"\n" ;

		var retMessage =  this.isFloat(ObjectName, ObjectDisplayName);
		if ( retMessage == "" )
		{
			objValue = this.replaceAll(objValue, ",","") ; //objValue.replace(",", "");
			objValueFloat = parseFloat(objValue);
			if ( objValueFloat <= 0  )
			{
				retMessage ="o  " + ObjectDisplayName +" can not be Negative or Zero\n" ;
				return retMessage;
			}

		}
		return retMessage;
	}//isPositiveFloat

	/*
	Validation routine for all type of Float value (isValidRate )
	It checks whether
		a) Passed parameter is a valid object or not
		b) Checking for null
		c) Checking for numeric/non-numeric value
		d) Checking for Negative and checking for 0 < val <= 100
	return : Validation message if occured else Empty String
	*/
	/*public String*/this.isValidRate = function(ObjectName, ObjectDisplayName)
	{
		if (  this.isObject(ObjectName) == false )
			return "VALIDATOR:isValidRate() : Undefined parameter for "+ ObjectDisplayName +"\n" ;

		var retMessage = this.isFloat(ObjectName, ObjectDisplayName);
		if ( retMessage == "" )
		{
			objValue = this.replaceAll(objValue, ",","") ; //objValue.replace(",", "");
			objValueFloat = parseFloat(objValue);
			if ( objValueFloat <= 0 )
			{
				retMessage ="o  " + ObjectDisplayName +" can not be Negative or Zero\n" ;
				return retMessage;
			}
			else if ( objValueFloat > 100 )
			{
				retMessage ="o  " + ObjectDisplayName +" can not be more than 100 \n" ;
				return retMessage;
			}
		}
		return retMessage;
	}//isPositiveFloat


	/*
	Validation routine for all type of Quantity/Integer etc. (isPositiveInteger)
	It checks whether
		a) Passed parameter is a valid object or not
		b) Checking for null
		c) Checking for numeric/non-numeric value
	return : Validation message if occured else Empty String
	*/
	/*public String*/this.isPositiveInteger = function(ObjectName, ObjDisplayName)
	{

		if (  this.isObject(ObjectName) == false )
			return "VALIDATOR:isPositiveInteger() : Undefined parameter for "+ ObjDisplayName +"\n" ;

		objValue = this.trim(ObjectName.value);
		var retMessage = "";

		if ( this.isNullValue(objValue) )
		{
			retMessage ="o  " + ObjDisplayName +" can not be empty\n" ;
			return retMessage;
		}

		objValue =this.replaceAll(objValue, ",","") ; // objValue.replace(",", "");
		objValueFloat = parseFloat(objValue);
		objValueInt = parseInt(objValue, 10); // radix=10

		if ( isNaN(objValue) )
		{
			retMessage ="o  " + ObjDisplayName +" must be Numeric\n" ;
			return retMessage;
		}
		if ( objValueFloat != objValueInt)
		{
			retMessage ="o  " + ObjDisplayName +" must be Integer\n" ;
			return retMessage;
		}
		if ( objValueFloat <= 0 )
		{
			retMessage ="o  " + ObjDisplayName +" can not be Negative or Zero\n" ;
			return retMessage;
		}
		return retMessage;
	}//isPositiveInteger

	/*public boolean*/this.isNull = function(arg)
	{
		//arg = this.trim(arg);
		return arg === null;
	}//---isNull

	/*public boolean*/this.isNullValue = function(val)
	{
		val = this.trim(val);
		return val ==="" || val === null;
	}//---isNull

	/*public boolean*/this.isNullObjectValue = function(ObjectName)
	{
		if (  this.isObject(ObjectName) == false )
		{
			alert(xenos.i18n.utilvalidatormessage.null_obj) ;
			return false;
		}
		objValue = this.trim(ObjectName.value);
		return this.isNullValue(objValue) ;
	}//---isNull

	/*public boolean*/this.isObject=function(arg)
	{
		//return !this.isNull(arg) && typeof(arg)==='object' && (arg.length===undefined);
		return typeof(arg)==='object';
	}	//---isObject

	/*public boolean*/this.isUndefined=function(arg)
	{
		return arg===undefined;
	}	//---isUndefined

	/**
	 * Function that will remove the leading and trailing spaces.
	 */
	this.trim = function (str) { 
		if (str == 'undefined' || str == null)
			return ;
		else
			return( this.rtrim(this.ltrim(str)) );
	}
	/**
	 * Function that will remove the trailing spaces.
	 */
	this.rtrim = function (str) { re = /(\s+)$/; return str.replace(re, ""); }
	/**
	 * Function that will remove the leading spaces.
	 */
	this.ltrim = function (str) { re = /^(\s+)/; return str.replace(re, ""); }

	this.replaceAll = function (str, oldChar, newChar)
	{
		for ( ; str.indexOf(oldChar) >= 0 ; )
			str = str.replace(oldChar, newChar);
		return str;
	}
	/**
	 * This method ensures that toDate cannot occur before fromDate and
	 */
	this.fromToDateCheck = function(fromDate, toDate) {
/*
		if(fromDate == null || fromDate == "" || toDate == null || toDate == "") {
			return true; // Both date have to be non null
		}

		if (fromDate > toDate) {
    
			return false;
		}*/
		return true;
	}
}

var VALIDATOR = new validation();