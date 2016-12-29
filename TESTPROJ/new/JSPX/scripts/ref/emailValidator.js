//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $



function validationOnAddEmailInfo()
{
    var validationMessage = "";
    validationMessage = validationMessage + VALIDATOR.checkForNull( document.getElementById("mailRecipient.toCcType"),"TO / CC Type");
    validationMessage = validationMessage + VALIDATOR.checkForNull( document.getElementById("mailRecipient.mailAddress"),"Address");
    
    if ( validationMessage != "")
    {
         alert(validationMessage);
         return false;
    }
    
	return true;
}