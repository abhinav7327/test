//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




/*****************************************************************************
 * Function for opening a new  window with user specified name and dimension.
 * @param url String URL to open
 * @param winName String Name of the window
 * @param height number height of the window
 * @param width number width of the window
 * @param bResize boolean reSizable property of window
 * @param bScroll boolean scrollbars property of window
 *****************************************************************************/
function openNamedWindow(url, winName, height, width,bResize,bScroll)
{
    var resizeStr = ",resizable=no";
	var scrollStr = ",scrollbars=no";
	if(bResize)
	{
		resizeStr = ",resizable=yes";
	}
	if(bScroll)
	{
		scrollStr = ",scrollbars=yes";
	}
	var left = (screen.availWidth - width) / 2 ;
	var top = (screen.availHeight - height) / 2;

	var prop = "height=" + height + ", width=" + width +",left="+ left +",top="+ top + resizeStr +  scrollStr;

    var winName = winName;
    var hWnd = window.open(url, winName, prop);

	hWnd.focus();

    if ((document.window != null) && (!hWnd.opener)) {
        hWnd.opener = document.window;
    }
}

/*****************************************************************************
 * Function for opening a new  window with generated window name and user specified dimension.
 * @param url String URL to open
 * @param height number height of the window
 * @param width number width of the window
 *****************************************************************************/
function openWindow(url,height, width)
{
	var left = (screen.availWidth - width) / 2 ;
	var top = (screen.availHeight - height) / 2;
	var prop = "height=" + height + ", width=" + width +",left="+ left +",top="+ top + ",resizable=no, scrollbars=no";

    var winName ='w'+Math.random().toString().substr(2);

    var hWnd = window.open(url, winName, prop);

    if ((document.window != null) && (!hWnd.opener)) {
        hWnd.opener = document.window;
    }
}
/*****************************************************************************
 * Function for opening a new  window for online XLS and PDF Reports.
 * @param method String method of dispatchAction (generateXLS and generatePDF)
 * @return false
 *****************************************************************************/
function openReportPopup(method){

	prop = "height=" + screen.availHeight + ", width=" + screen.availWidth + ",resizable=yes, scrollbars=no,menubar = no, toolbar=no,top=0,left=0";
	var winName ='w'+Math.random().toString().substr(2);
	var url = document.forms[0].action;
	//var url= location.href;
	var  newFormAction ="";

    /************************************************
    ? sign not exists in the form Action
    just append it to the exisiting formAction
    and append the method to form the new formAction
    *************************************************/
	if(url.indexOf('?')==-1)
    {
        newFormAction = url + '?' + method;
    }
    else
    {
        /*********************************************
          substring formAction upto '?' sign and append action to it
        **********************************************/
        uri = url.substr(0,url.indexOf('?'));
        newFormAction = uri + '?' + method;
    }
	//url = newFormAction;
	var randStr ='r'+Math.random().toString().substr(5);
	//alert(randStr);
	//alert(newFormAction);
	// create new dummy window
	var reportwindow = window.open('', winName, prop);

	// check the existance of dummyform in DOM
	// if found set the new action or create a new dumyForm and set the action
	if(!document.getElementById('dummyForm'))
	{
		var newform = document.createElement("<form name='dummyForm' method='POST' action='"+newFormAction+"'> </form>")
		document.body.appendChild(newform);

	} else {
		document.getElementById('dummyForm').action=newFormAction;
	}
	// set the target of dummyForm and submit it.
	document.getElementById('dummyForm').target=winName;
	document.getElementById('dummyForm').submit();

	if ((document.window != null) && (!reportwindow.opener)) {
			reportwindow.opener = document.window;
	}
	return false;
}

