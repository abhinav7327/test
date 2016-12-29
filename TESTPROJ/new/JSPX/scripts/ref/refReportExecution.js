//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $





function validateMandatory()
{
    var validationMessage = "";
    validationMessage = VALIDATOR.checkForNull( document.getElementById("reportId"),"Report Name");
    
    if ( validationMessage != "")
    {
         alert(validationMessage);
         return false;
    }
    
	return true;
}
