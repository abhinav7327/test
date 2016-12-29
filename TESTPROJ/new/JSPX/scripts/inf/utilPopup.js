//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




/*
* Method For Reseting the Hidden Form to be populated from the params supplied by the user
*/
function resetForm()
{
	document.forms[1].innerHTML = "";	
}

/*
* @pupose	: prepare the reuturn value array as 
			  parentForm filed name and  value pair. 
			  Set the array to window.returnValue object 
			  and close the window
* @name		: returnValuesToParentModalWindow
* @param	: (Array) valueArr
* @param	: (object) oForm (html Form Object i.e. document.form) 
*/
function  returnValuesToParentModalWindow(valueArr,oForm)
{
	var retValueArray = new Array();
	//alert(window.dialogArguments.length);
	for(i =0;i<window.dialogArguments[1].length;i++ )
	{
		//alert(window.dialogArguments[1][i]);
	}
	// prepare the parent field(s) and value array 
	//if(oForm.elements.length > 1)
	if(window.dialogArguments[1].length > 1)
	{
		for(j=0;j<window.dialogArguments[1].length;j++)
		{
			retValueArray[j] = new Array(2);
		}
	}
	else
	{
		retValueArray[0] =  new Array(2);
	}

    //if(oForm.elements.length > 1)
	if(window.dialogArguments[1].length > 1)
	{
	
		for (i=0;i<window.dialogArguments[1].length;i++)
		{
			//retValueArray[i][0] = oForm.key[i].value;
		    // replace all "9" with "." as we need to revert back to original property name 		
			//retValueArray[i][0] = oForm.key[i].value.replace(/9/gi,".");
			retValueArray[i][0] = window.dialogArguments[1][i];
			retValueArray[i][1] = valueArr[i];
		}
	}
	else
	{
		//retValueArray[0][0] = oForm.key.value;
		// replace all "9" with "." as we need to revert back to original property name 
		//retValueArray[0][0] = oForm.key.value.replace(/9/gi,".");
		retValueArray[0][0] = window.dialogArguments[1];
		retValueArray[0][1] = valueArr[0];
	}
	// set the prepared return value array to window.returnValue object & close the window
	window.returnValue = retValueArray;

	// call cleanup method for Popup with to close all open connection
	// this method in turn call customOnPopupSelectMethod if exist 
	//in the calling page other wise do nothing.
	cleanupPopup();

	window.close();
}


/*
* @pupose	: populate request Value array as 
			  parentForm filed name and  value pair. 
			  Set the array to window.returnValue object 
			  and close the window
* @name		: returnValuesToParentModalWindow
* @param	: (Array) valueArr
* @param	: (object) oForm (html Form Object i.e. document.form) 
*/

function populateRequest(dependentsParams, targetParams,baseAction,method,bModal,nWidth,nHeight)
{
	if(bModal)
	{
		var argArr = new Array(dependentsParams,targetParams,baseAction,method);

		
		// prepare the dependents query String from dependentArray (dependentsParams)
		var dStr ="";
		for (i=0;i<dependentsParams.length ;i++ )
		{
			// store original value
			var originalStr = dependentsParams[i];
			// replace . with 9 and store into a new var. As java try to resolve anything before  a dot[.] as object
			var newStr = originalStr.replace(/\./gi,"9");	
			// replace [ with 8 and store into a new var. As java try to resolve anything before  a dot[.] as object
			 newStr = newStr.replace(/\[/gi,"8");
			// replace ] with 7 and store into a new var. As java try to resolve anything before  a dot[.] as object
			 newStr = newStr.replace(/\]/gi,"7");
			

			var objVal= document.getElementById(dependentsParams[i]).value;
			//dStr+="&dependents("+dependentsParams[i]+")="+objVal;
			dStr+="&dependents("+newStr+")="+objVal;
		}
	
        // prepare the targets query String from targetArray (targetParams)
		var tStr ="";
		for (i=0;i<targetParams.length ;i++ )
		{
			// store original value
			var originalStr = targetParams[i];
			// replace . with 9 and store into a new var. As java try to resolve anything before  a dot[.] as object
			var newStr = originalStr.replace(/\./gi,"9");
			// replace [ with 8 and store into a new var. As java try to resolve anything before  a dot[.] as object
			 newStr  = newStr.replace(/\[/gi,"8");
			// replace ] with 7 and store into a new var. As java try to resolve anything before  a dot[.] as object
			 newStr  = newStr.replace(/\]/gi,"7");

			var objVal= document.getElementById(targetParams[i]).value;
			//tStr+="&targets("+targetParams[i]+")=";
			tStr+="&targets("+newStr+")=";
		}
		nWidth+=175;
		var retVal=window.showModalDialog(baseAction+method+dStr+tStr,argArr,"scroll:yes; dialogWidth:"+nWidth+"px; dialogHeight:"+nHeight+"px; center:yes");
		//alert(baseAction+method+dStr+tStr);
		//var retVal=window.open(baseAction+method+dStr+tStr,'',"scroll:yes; dialogWidth:"+nWidth+"px; dialogHeight:"+nHeight+"px; center:yes");
	}
	else // here is a option to open a non-modal window but now its a modal Implementation. A scope for future change if any. 
	{
		var retVal=window.showModalDialog(baseAction+method+dStr+tStr,argArr,"scroll:yes; dialogWidth:"+nWidth+150+"px; dialogHeight:"+nHeight+"px; center:yes");
	}
	// if retVal is null Alert and set nothing in parent Form 
	if (retVal == null)
	{
		//window.alert("Nothing returned from child. No changes made to Parent Form");
	}
	else
	{
		// update the value(s) to the respective field(s) from the array returned from the child Window(Modal)
		try{	
		for(i=0;i<retVal.length;i++)
		{
			var oField = document.getElementById(retVal[i][0]);
			if(oField)
			{
						//Check weather the retrieved value comes from login page or not.
						if(retVal[0][1]=="sessionInvalidate"){							
							if(!parentExists()){
								// if parent does not exists the reload the page.
								//window.location.reload();
								window.location.href = window.location;
							}
							else{								
								//If parent exists the submitting the form of the child page.									
								document.forms[0].submit();									
							}															
						}
						else{
							//If reponse comes from some other page rather than login page 
							//then we set the value for the request field. 
							oField.value = retVal[i][1];						
						}
					}
					else{	
						//If response comes from login page with no value 
						//then we will submit the page
						if(retVal[0][1]=="sessionInvalidate"){	
							document.forms[0].submit();
						}
					}
			} // end for		
		}
		catch(err)
		{
			// do nothing...
		}
	} // (retVal == null)	

}

/*
* @pupose	: This function checks whether 
              window has any parents
			  reference or not. If Parent exists, 
			  then it retruns true otherwise false.
* @name		: parentExists
* @return	: true / false
*/
function parentExists()
{
	var opener = window.dialogArguments;
	return (opener == null)?false:true;
}

/*
 * @purpose	: this function is same as the populateRequest function defined above except that it fires the 
              onchange event on the fields specified in the targetParams.
			  This function has been added to fire the onchange event in the parent window fields. In the
			  populateRequest function, even if an event is defined on a field specified in the target array,
			  it doesn't get called when control goes back to the parent page. This behavior is observed in 
			  IE 7/8 but in IE 6 we are able to handle it in a different way.
 * @name	: populateRequestCustom
 * @see		: populateRequest(dependentsParams, targetParams, baseAction, method, bModal, nWidth, nHeight)
 */
function populateRequestCustom(dependentsParams, targetParams, baseAction, method, bModal, nWidth, nHeight) {
	if(bModal) {
		var argArr = new Array(dependentsParams,targetParams,baseAction,method);

		// prepare the dependents query String from dependentArray (dependentsParams)
		var dStr ="";
		for (i=0;i<dependentsParams.length ;i++ ) {
			// store original value
			var originalStr = dependentsParams[i];
			// replace . with 9 and store into a new var. As java try to resolve anything before  a dot[.] as object
			var newStr = originalStr.replace(/\./gi,"9");	
			// replace [ with 8 and store into a new var. As java try to resolve anything before  a dot[.] as object
			newStr = newStr.replace(/\[/gi,"8");
			// replace ] with 7 and store into a new var. As java try to resolve anything before  a dot[.] as object
			newStr = newStr.replace(/\]/gi,"7");

			var objVal= document.getElementById(dependentsParams[i]).value;
			//dStr+="&dependents("+dependentsParams[i]+")="+objVal;
			dStr+="&dependents("+newStr+")="+objVal;
		}

		// prepare the targets query String from targetArray (targetParams)
		var tStr ="";
		for (i=0;i<targetParams.length ;i++ ) {
			// store original value
			var originalStr = targetParams[i];
			// replace . with 9 and store into a new var. As java try to resolve anything before  a dot[.] as object
			var newStr = originalStr.replace(/\./gi,"9");
			// replace [ with 8 and store into a new var. As java try to resolve anything before  a dot[.] as object
			newStr  = newStr.replace(/\[/gi,"8");
			// replace ] with 7 and store into a new var. As java try to resolve anything before  a dot[.] as object
			newStr  = newStr.replace(/\]/gi,"7");
			
			var objVal= document.getElementById(targetParams[i]).value;
			//tStr+="&targets("+targetParams[i]+")=";
			tStr+="&targets("+newStr+")=";
		}
		
		nWidth+=175;
		var retVal=window.showModalDialog(baseAction+method+dStr+tStr,argArr,"scroll:yes; dialogWidth:"+nWidth+"px; dialogHeight:"+nHeight+"px; center:yes");
	} else {
		// here is a option to open a non-modal window but now its a modal Implementation. A scope for future change if any. 
		var retVal=window.showModalDialog(baseAction+method+dStr+tStr,argArr,"scroll:yes; dialogWidth:"+nWidth+150+"px; dialogHeight:"+nHeight+"px; center:yes");
	}
	
	// if retVal is null Alert and set nothing in parent Form
	if (retVal == null) {		
		//window.alert("Nothing returned from child. No changes made to Parent Form");
	} else { 
		// update the value(s) to the respective field(s) from the array returned from the child Window(Modal)
		try {
			for(i=0;i<retVal.length;i++) {
				var oFieldId = retVal[i][0];
				var oField = document.getElementById(retVal[i][0]);
				if(oField) {
					//Check weather the retrieved value comes from login page or not.
					if(retVal[0][1]=="sessionInvalidate") {
						if(!parentExists()) {
							// if parent does not exists the reload the page.
							//window.location.reload();
							window.location.href = window.location;
						} else{
							//If parent exists the submitting the form of the child page.
							document.forms[0].submit();
						}
					} else {
						//If response comes from some other page rather than login page 
						//then we set the value for the request field. 
				oField.value = retVal[i][1];
						fireEvent(oField, "change");
					}
				} else {
					//If response comes from login page with no value 
					//then we will submit the page
					if(retVal[0][1]=="sessionInvalidate") {
						document.forms[0].submit();
					}
			}				
		} // end for
		} catch(err) {
			// do nothing...
		}
	} // (retVal == null)	
}

/**
 * Function to fire an event on a field
 */
function fireEvent(element, event) {
    if (document.createEventObject) {
		// dispatch for IE
		var evt = document.createEventObject();
		return element.fireEvent('on'+event,evt)
    } else {
		// dispatch for firefox + others
		var evt = document.createEvent("HTMLEvents");
		evt.initEvent(event, true, true ); // event type,bubbling,cancelable
		return !element.dispatchEvent(evt);
    }
}