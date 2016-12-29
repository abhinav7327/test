//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




function executeAction(isValid, action)
{
    if (isValid==false)
    {
        return false;
    }
    
    // null and empty check string
    if(!action || action=="" || action==null)
    {
        alert("No Action specified in <xenos:image tag>.\n\n Please Specify the action.")
    }

    var formAction= document.forms[0].action;
    var newFormAction = "";    

    /************************************************
    ? sign not exists in the form Action
    just append it to the exisiting formAction 
    and append the action to form the new formAction
    *************************************************/
    if(formAction.indexOf('?')==-1)
    {
        newFormAction = formAction + '?' + action;
    }
    else
    {
        /*********************************************
          substring formAction upto '?' sign and append action to it
        **********************************************/
        uri = formAction.substr(0,formAction.indexOf('?'));
        newFormAction = uri + '?' + action;
    }
    // set formAction to new action 
    document.forms[0].action = newFormAction;

    hideBodyNshowProcessing();   
}    

/************************************************************
 Javascripts Hooks for Body Events (onclick,onload,onfocus)
************************************************************/
customOnLoadMethod = null;
customPopupCleanupMethod = null;
customOnFocusMethod = null;
customOnclickMethod =null;
updateTopFrame = null;
function onclickPage()
{
    customOnclickMethod ? customOnclickMethod() : null;
}
function initPage ()
{
    updateTopFrame ? updateTopFrame() : null;
    customOnLoadMethod ? customOnLoadMethod() : null;
    if (updateTopFrame){
    	top.topFrame.dummy.focus();
    }
}
/**
* Function to customPopupCleanupMethod connection
* if customPopupCleanupMethod custom function existis in the calling page then 
* only it invoke the customPopupCleanupMethod function. 
*/
function cleanupPopup()
{
	customPopupCleanupMethod ? customPopupCleanupMethod() : null;
}
function focusPage ()
{
    customOnFocusMethod ? customOnFocusMethod() : null;
}
function hideBodyNshowProcessing()
{    
        document.getElementById('xenosPage').style.display="none";
        document.getElementById('loading').style.display="block";    

}

/************************************************************
 * Javascripts method for submiting form from hyperlink
 * @param  String action (action with the params)
 * @ return void()
 *
 * Example usage :
 *  <a href="javascript:linkSubmit('xyz.action?method=yourMethod&param1=value1&param2=<c:out value="${someValue}"/>')">hyperLink</a>
 *  <a href="javascript:linkSubmit('xyz.action?method=yourMethod&param1=value1&param2=<c:out value="${someValue}"/>')"><xenos:img srcKey="inf.image.icon.iconedit" bundle="infRes" border="0"/></a>
 *  
 **********************************************************/

function linkSubmit(action)
{
    if(action)
    {
        hideBodyNshowProcessing();
	document.forms[0].action = action;
        document.forms[0].submit();
    }
    else
    {
        alert("No Action Found. Unable to Post the Form ");
    }
}

