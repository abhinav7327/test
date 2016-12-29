//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $





/**
 *  Validates the selection criteria for Cam Ledger Balance Query set by the user for the mandatory fields.
 */
 function validateSubmit()
{
    var alertStr = "";
    if(document.getElementById("reportId").value == "")
    {
        alertStr+=" Please Select Report ID\n";
    
    }    
   if(alertStr != "")
    {
    alert(alertStr);
    return false;
    }
    return true;
}

