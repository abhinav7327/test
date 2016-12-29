//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $



 
/*
* @pupose	: This function send a constant value to its 
              parent and then close the self window.
* @name		: closeModalWindow
*/ 
function closeModalWindow()
{		
	//Before closing the Modal child window we returns a 
	//constant value 'sessionInvalidate' to its parent window. 
	//In the parent if the constant exists then we will reload the parent.  	
	var retValueArray = new Array();
	retValueArray[0] = new Array(2);
	retValueArray[0][0] = window.dialogArguments[1];
	retValueArray[0][1] = "sessionInvalidate";				
	window.returnValue = retValueArray;					
    window.close();	
}

/*
* @pupose	: This function close all the Non Modal 
              child pages and reload the login page 
			  at top most parent page.
* @name		: closeChildWindow
*/
function closeChildWindow()
{	
	//Getting window name. 'A' is appended for window name as null	
	windowName = window.name+"A";
	//At the topmost level window name is used as xenos
	//So, if we are not at the topmost level then we 
	//have to close the window.
	if(windowName.match("xenos")==null){
		if(windowName.match("Frame")=="Frame"){
			//AS we can't close a window unless it is opened by a script. 
			//so the walkaround will be to let the browser thinks that this 
			//page is opened using a script then closing the window.
			//So, window.open('','_self','') is used before window.close()
			window.open('','_self','');	
			window.close();	
		}
		else{
			//Getting the URL for parent window.
			openerURL = opener.location.href
			//For very first level main.action called. So, browser 
			//will check weather it is at topmost level. if not, then 
			//it will reload the parent page and close self.			
			if(openerURL.match("main.action")==null)
			{	
				//Refresh the parent window before closing the child window
				//window.opener.location.reload();				
				window.opener.location.href = window.opener.location;
				window.close();																
			}
		}
	}
}

/*
* @pupose	: This function checks whether 
              Modal window has any parents
			  reference or not. If Parent exists, 
			  then it retruns true otherwise false.
* @name		: parentModalExists
* @return	: true / false
*/
function parentModalExists(){
	var opener = window.dialogArguments;
	return (opener == null)?false:true;
}

/*
* @pupose	: This function checks whether 
              Non-Modal window has any parents
			  reference or not. If Parent exists, 
			  then it retruns true otherwise false.
* @name		: parentExists
* @return	: true / false
*/
function parentExists(){
    return (window.opener != null)? true : false;
}