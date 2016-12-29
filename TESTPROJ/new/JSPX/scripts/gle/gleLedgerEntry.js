//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
// $Id$
// $Revision: 1.2 $
// $Date: 2016-12-23 12:20:54 $

/*
 * +=======================================================================+
 * |                                                                       |
 * |          Copyright (C) 2000-2004 Nomura Securities Co., Ltd.          |
 * |                          All Rights Reserved                          |
 * |                                                                       |
 * |    This document is the sole property of Nomura Securities Co.,       |
 * |    Ltd. No part of this document may be reproduced in any form or     |
 * |    by any means - electronic, mechanical, photocopying, recording     |
 * |    or otherwise - without the prior written permission of Nomura      |
 * |    Securities Co., Ltd.                                               |
 * |                                                                       |
 * |    Unless required by applicable law or agreed to in writing,         |
 * |    software distributed under the License is distributed on an        |
 * |    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,       |
 * |    either express or implied.                                         |
 * |                                                                       |
 * +=======================================================================+
 */

function customOnLoadMethod()
{	
	diableOnLoad();
}



function validationForEntry(form)
{
	var subcodeHeads = new Array('strategy','account','product','affiliate','rrnumber');

	var subcodesMissing = "";
	
	var alertStr = "";
	
	for(i=0;i<subcodeHeads.length;i++)
	{		
		if(document.forms[0].selector[i].checked)
		{  				
			//alert(subcodeHeads[i]);  	
			//alert(document.forms[0].selector[i].checked);
			if(document.getElementById(subcodeHeads[i]+"LedgerSubcode.subcodeReqd").selectedIndex == 1)
			{		
				//alert(document.getElementById(subcodeHeads[i]+"LedgerSubcode.subcodeReqd").selectedIndex);
				if(document.getElementById(subcodeHeads[i]+"LedgerSubcode.defaultSubcode").value=="")
				{
					//alert(document.getElementById(subcodeHeads[i]+"LedgerSubcode.defaultSubcode").value);
					//alert("Please enter the value of the default subcode for " + subcodeHeads[i]);
					//return false;  
					subcodesMissing += "," +  subcodeHeads[i]
				}
			}
		}	
	}	
	
	if(subcodesMissing != "")
	{
		alert("Please enter the value of the default subcode for " + subcodesMissing.substr(1));
		return false;
	}

	if(trim(document.getElementById("ledgerOb.ledgerCode").value).length < 1){
		
		alertStr += "\n    o Ledger Code"
		//alert('Ledger Code and Short name are mandatory fields and need to be filled');
		//return false;
	}
	
	if(trim(document.getElementById("ledgerOb.shortName").value).length < 1){

		alertStr += "\n    o Short name"
		//alert('Ledger Code and Short name are mandatory fields and need to be filled');
		//return false;
	}
		
	if(alertStr!=""){
		alertStr += "\n    need to be filled"
		alert(alertStr);
		return false;
	}
		form.action="gleLedgerEntryDispatchAction.action?method=doEntry";
	    return true;
}

function validationForAmend(form)
{	
  
	var subcodeHeads = new Array('strategy','account','product','affiliate','rrnumber');

	var subcodesMissing = "";
	
	for(i=0;i<subcodeHeads.length;i++)
	{	
	
		if(document.forms[0].selector[i].checked)
		{  
	
			//alert(subcodeHeads[i]);  	
			//alert(document.forms[0].selector[i].checked);
			if(document.getElementById(subcodeHeads[i]+"LedgerSubcode.subcodeReqd").selectedIndex == 1)
			{	
			
				//alert(document.getElementById(subcodeHeads[i]+"LedgerSubcode.subcodeReqd").selectedIndex);

			}
		}	
	}	
	
	if(subcodesMissing != "")
	{
		alert("Please enter the value of the default subcode for " + subcodesMissing.substr(1));
	
		return false;
	}


	if(trim(document.getElementById("ledgerOb.shortName").value).length < 1){
		alert('Short name is a mandatory field and need to be filled');
	
		return false;
		}
	
	form.action="gleLedgerAmendDispatchAction.action?method=doAmend";	
	return true;
}




function requiredChange(subcode)
{	  
   alert("requiredChange");
	if(document.getElementById(subcode+"LedgerSubcode.subcodeReqd").selectedIndex == 0)	
	{
		document.getElementById(subcode+"LedgerSubcode.defaultSubcode").disabled = true;
		//document.getElementById(subcode+"LedgerSubcode.defaultSubcode").value = "";
	}
	else
		document.getElementById(subcode+"LedgerSubcode.defaultSubcode").disabled = false;
}
  
  
  
function addChange(subcode)
{  
	var subcodeHeads = new Array('strategy','account','product','affiliate','rrnumber');  	
	if(document.forms[0].selector[subcode].checked)
	{
		document.getElementById(subcodeHeads[subcode]+"LedgerSubcode.subcodeReqd").disabled = false;
		document.getElementById(subcodeHeads[subcode]+"LedgerSubcode.ledgerSubcodeTypePk").disabled = false;
		if(subcode==0){
		document.getElementById(subcodeHeads[subcode]+"LedgerSubcode.defaultSubcode").disabled = false;
		}
		
	}
	else
	{
		document.getElementById(subcodeHeads[subcode]+"LedgerSubcode.subcodeReqd").disabled = true;
		document.getElementById(subcodeHeads[subcode]+"LedgerSubcode.ledgerSubcodeTypePk").disabled = true;
		if(subcode==0){
		document.getElementById(subcodeHeads[subcode]+"LedgerSubcode.defaultSubcode").disabled = true;
		}
		//document.getElementById(subcodeHeads[subcode]+"LedgerSubcode.defaultSubcode").value = "";
	}	
}




  
function diableOnLoad()
{    	

	var i;
	var subcodeHeads = new Array('strategy','account','product','affiliate','rrnumber');	
	for(i=0;i<subcodeHeads.length;i++)
	{				
		if(!document.forms[0].selector[i].checked)
		{
			document.getElementById(subcodeHeads[i]+"LedgerSubcode.subcodeReqd").disabled = true;
			document.getElementById(subcodeHeads[i]+"LedgerSubcode.ledgerSubcodeTypePk").disabled = true;
			if(i==0)
			document.getElementById(subcodeHeads[i]+"LedgerSubcode.defaultSubcode").disabled = true;
			
		}

	}	
}


/*
function diableOnLoad()
{    	
var i;
var subcodeHeads = new Array('strategy','account','product','affiliate','rrnumber');
for(i=0;i<subcodeHeads.length;i++)
{		
	document.getElementById(subcodeHeads[i]+"LedgerSubcode.subcodeReqd").disabled = true;
	document.getElementById(subcodeHeads[i]+"LedgerSubcode.ledgerSubcodeTypePk").disabled = true;
	document.getElementById(subcodeHeads[i]+"LedgerSubcode.defaultSubcode").disabled = true;
	//document.getElementById(subcodeHeads[i]+"LedgerSubcode.defaultSubcode").value = "";
}	
}
*/



//old functions
/*  
  function somechange(subcode)
  {
	if(document.forms[0].required[subcode].selectedIndex == 0)
		document.forms[0].defaultType[subcode].disabled = true;
	else
		document.forms[0].defaultType[subcode].disabled = false;
    	
    	document.getElementById("selectedDefaultValue").value = document.forms[0].defaultType[subcode].value;    	
    	document.getElementById("selectedSubcodetype").value = document.forms[0].subCodeType[subcode].value;   	
    	document.getElementById("selectedRequired").value = document.forms[0].required[subcode].value;
  }
*/
/*
  function addChange(subcode)
  {  
  	//var subcodeHeads = new Array(0,1,2,3,4);
  	var i=0;  	
  	for(i=0;i<5;i++)
  	{
  		if(subcode == i)
  			continue;	
  		document.forms[0].pk[i].checked = false;
  		document.forms[0].defaultType[i].disabled = true;  	
  		document.forms[0].subCodeType[i].disabled = true;
  		document.forms[0].required[i].disabled = true;
  	}
  	
    	if(document.forms[0].pk[subcode].checked)
    	{
  		document.forms[0].defaultType[subcode].disabled = false;
  		document.forms[0].subCodeType[subcode].disabled = false;
  		document.forms[0].required[subcode].disabled = false;
		if(document.forms[0].required[subcode].selectedIndex == 0)
			document.forms[0].defaultType[subcode].disabled = true;
		else
			document.forms[0].defaultType[subcode].disabled = false;
    	}
    	else
    	{
  		document.forms[0].defaultType[subcode].disabled = true;
  		document.forms[0].subCodeType[subcode].disabled = true;
  		document.forms[0].required[subcode].disabled = true;
    	}    	    	
    	
    	document.getElementById("selectedDefaultValue").value = document.forms[0].defaultType[subcode].value;
    	document.getElementById("selectedSubcodetype").value = document.forms[0].subCodeType[subcode].value;
    	document.getElementById("selectedRequired").value = document.forms[0].required[subcode].value;
  }
*/

/*	
  function diableOnLoad()
  {    	
  	var i=0;  	

  	for(i=0;i<5;i++)
  	{
  		document.forms[0].pk[i].checked = false;
  		document.forms[0].defaultType[i].disabled = true;  	
  		document.forms[0].subCodeType[i].disabled = true;
  		document.forms[0].required[i].disabled = true;
  		//alert(i);
  	}
  }	
*/

