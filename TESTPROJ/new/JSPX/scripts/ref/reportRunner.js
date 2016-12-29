//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $



 
/**
 * Show and Hide the JVM options:
 *
 */

 function showHideJVMoptions(obj) 
{
    var visibleFlag = false;

    switch (obj.value)
    {

        case "12761" :
            
            visibleFlag = true;
            break;
        default :
            visibleFlag = false;
            break;
    }
    
    if (visibleFlag) 
    {
        document.getElementById('javaMemoryLbl').style.display = "inline";
        document.getElementById('javaMemoryVal').style.display = "inline";
    } 
    else 
    {
        document.getElementById('javaMemoryLbl').style.display = "none";
        document.getElementById('javaMemoryVal').style.display = "none";
    }
}