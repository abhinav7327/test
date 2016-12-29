//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $



 /**
* Validate sort order fields.
*/
function validateClientManagementCustomerRestrictionQuery() {
	
	var alertMsg = "";

	var sortOrderField1 = document.getElementById("sortOrderField1").value;
	var sortOrderField2 = document.getElementById("sortOrderField2").value;
	var sortOrderField3 = document.getElementById("sortOrderField3").value;
    
	if((sortOrderField1!="" && sortOrderField1==sortOrderField2) || 
		(sortOrderField2!="" && sortOrderField2==sortOrderField3) || 
		(sortOrderField3!="" && sortOrderField3==sortOrderField1)) {
		alertMsg = "o  The Sort Fields must be different from each other";
	}
	
	if(alertMsg!="") {
		alert(alertMsg);
		return false;
    }
	
	return true;
}

/**
* Function to check all the checkbox values.
*/
function checkFeedQueryAllInResultPage() {
	if(document.forms[0].customePkArray.length) {
		for(var i= 0 ; i< document.forms[0].customePkArray.length;i++) {
			    if (!document.forms[0].customePkArray[i].disabled )
			    {
					document.forms[0].customePkArray[i].checked = document.forms[0].chk.checked;
			    }
		}
	} else {
		document.forms[0].customePkArray.checked = document.forms[0].chk.checked;
	}
	document.getElementById("checkAll").value=true;
}
/**
* Function to give alert when no checkbox selected and Submit is clicked
*/
function showSelectedRecMsg() {
    var count = getSelectedCount();
	if(count < 1){
		alert("Please select at least One Restriction Info for this action.");
		return false;
	}
	if(document.forms[0].chk.checked==true) {		
		document.getElementById("checkAll").value=true;
	}
		return true;

}
/**
* Function returns the no. of checkbox selected in query result page
*/
function getSelectedCount() {
	var vCnt=0;
	if(!document.forms[0].customePkArray.length) {
        if(document.forms[0].customePkArray.checked) {
            vCnt=parseInt(vCnt)+1;
        }
    } else {
    	var len=document.forms[0].customePkArray.length;
    	if(len > 0) {
    		for(var i= 0 ; i< document.forms[0].customePkArray.length;i++) {
    		    if (document.forms[0].customePkArray[i].checked==true )
    		    {
    				vCnt=parseInt(vCnt)+1;
    		    }				
    		}
    	}
    }
	return vCnt;
}

/**
* Function to reset the check all checkbox.
*/
function checkFeedQueryInResultPage() {			
	if(document.forms[0].chk.checked==true) {
		document.forms[0].chk.checked=false;
		document.getElementById("checkAll").value=false;
	}
}