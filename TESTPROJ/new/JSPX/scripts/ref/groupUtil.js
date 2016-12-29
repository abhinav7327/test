//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $





function validate()
{
	var msgStr="";
	
	if(!validateGroupName()){		
		msgStr+= "o Group Name Can Not Be Empty.\n";		
	}
	if(!validateGroupOrder()){		
		msgStr+= "o Group Order Can Not Be Empty.\n";		
	}
	if(!validateGroupOrderIsInt()) {
		msgStr+= "o Group Order must Be Integer.\n";	
	}
	/*if (!validateApplRole())
	{
		msgStr+= "o Please Select At Least One Component.\n";		
	}*/
	if(!validationOnAddToComponentNames()) {
		msgStr+= "o Select at least one component.\n";	
	}
	if (trim(msgStr).length>0)
	{
		alert(msgStr);
		return false;
	}
	//validationOnAddToComponentNames();
	return true;
}



/*
* validate Group name
*/
function validateGroupName()
{
	if (trim(document.getElementById('groupPage.dbdGroupName').value).length==0 )
	{		
		return false;
	}else{
		return true;
	}
}

/*
* validate Group Order
*/
function validateGroupOrder()
{
	if (trim(document.getElementById('groupPage.dbdGroupOrder').value).length==0 )
	{		
		return false;
	}else{
		return true;
	}
}

/*
* validate Group Order Integer
*/
function validateGroupOrderIsInt()
{
	if(isNaN(parseInt(trim(document.getElementById('groupPage.dbdGroupOrder').value)))) {
		return false;
	}else{
		return true;
	}
}

/*
* validate Last Name
*/
function validateLastName()
{
	if (trim(document.getElementById('emppage.lastName').value).length==0 )
	{		
		return false;
	}else{
		return true;
	}
}


/*
* validate applicationRole
*/
function validateApplRole()
{
	var oApplrole=document.getElementsByName('selectedComponents');
	if (oApplrole.length>0)
	{		
		for (i=0;i<oApplrole.length ;i++ )
		{
			if (oApplrole[i].checked)
			{
				return true;
			}
		}
		return false;
	}
	return true;
}

function changeAction()
{
	document.forms[0].action="../ref/groupQueryDispatch.action";
	return true;
}

/**
 * This function validates whether the application role is selected or not.
 *
 */
function validationOnAddToComponentNames()
{
    var validationMessage = "";
    
    validationMessage = validationMessage + VALIDATOR.checkForNull( document.getElementById("selectedComponents"),"Group Component");
    
    
    if ( validationMessage != "")
    {
         //alert(validationMessage);
         return false;
    }
    
	return true;
}