//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




function changeDispatchAction()
{
    
    document.forms[0].action="../ref/strategyQueryDispatch.action";
    return true;
}

function validationForEntry(form)
{   
   var validationMessage = "";
   
   if(trim(document.getElementById("strategyCode").value).length < 1){
       validationMessage = validationMessage + "o  Strategy Code must not be empty.\n"; 
   }
  
  if(trim(document.getElementById("shortName").value).length < 1 ){
        validationMessage = validationMessage + "o  Short Name must not be empty.\n";
    }

   if(trim(document.getElementById("strategyParentCode").value).length < 1){
       validationMessage = validationMessage + "o  Strategy Parent Code must not be empty.\n"; 
   }

  if ( validationMessage != "")
    {
        alert(validationMessage);
        return false;
    }
 
    return true;
}

function validationOnReasonPk()
{
    var validationMessage = "";
    
    
    validationMessage = validationMessage + VALIDATOR.checkForNull( document.getElementById("historyReasonPk"),"Reason Code");

    if ( validationMessage != "")
    {
         alert(validationMessage);
         return false;
    }
    
    return true;
}
