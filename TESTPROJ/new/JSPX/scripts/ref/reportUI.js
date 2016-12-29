//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
// $Id: reportUI.js,v 1.1.1.1 2010/07/09 09:46:55 




 /**  
 * This java script file contains validation related to the UI of CustomerStatementReport where either of any 
 * field value of FromDate/ToDate or BaseDate or Business Day can be given.The validation valid only for CSTMT
 * report.
 */
function validateSubmit(){

var reportId = document.getElementById('reportId').value;
if(reportId == "CSTMT"){
 return validateCSTMT();
 
}
return true;
}

function isBlank(str) 
{

    if(str == null || trim(str) == '') 
    {
        return true
    }
    return false
} 

function validateCSTMT(){

var businessDay = document.getElementById('value(CAM.GenerateCustomerStatement-y)').value;
if(!isBlank(businessDay)){
		if( !validateBusinessday()){
		return false;
         }
}

var fromDate = document.getElementById('value(CAM.GenerateCustomerStatement-f)').value;

var toDate = document.getElementById('value(CAM.GenerateCustomerStatement-t)').value;

var baseDate = document.getElementById('value(CAM.GenerateCustomerStatement-d)').value;



if((!isBlank(fromDate) || !isBlank(toDate))  && !isBlank(baseDate) && !isBlank(businessDay)) {
                        alert("FromDate/ToDate and BaseDate and BusinessDay can't be together");
						return false;
}
						
if((!isBlank(fromDate) || !isBlank(toDate))  && !isBlank(baseDate)) {
						alert("FromDate/ToDate and BaseDate can't be together")
						return false;
}	
if((!isBlank(fromDate) || !isBlank(toDate))  && !isBlank(businessDay)) 	{
						alert("FromDate/ToDate and BusinessDay can't be together");
						return false;
}
if(!isBlank(baseDate) && !isBlank(businessDay)){
						alert("BaseDate and BusinessDay can't be together");
						return false;
}	

return true;
}

/**  
 * The validation done to check the businessday field for only positive numeric value and all validation written in 
 *  utilValidator.js.
 */

function validateBusinessday(){

var validationMessage = "";
  	validationMessage = VALIDATOR.isPositiveInteger( document.getElementById('value(CAM.GenerateCustomerStatement-y)'),"Business Day");
 	if ( validationMessage != "")
 	{
 		alert(validationMessage);
 		return false;
 	}
	return true;
}

function validateDate(inputDate){
var value =	document.getElementById(inputDate).value
dateValidation(value);
}