//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
function validateClientManagementQuery() {
	
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
	
	document.getElementById('settlementFor').disabled=false;
	document.getElementById('cashSecurityFlag').disabled=false;
	document.getElementById('marketCode').disabled=false;
	document.getElementById('instrumentType').disabled=false;
	document.getElementById('instrumentCode').disabled=false;
	document.getElementById('settlementCcy').disabled=false;
	document.getElementById('deliveryMethod').disabled=false;
	document.getElementById('ssiStatus').disabled=false;
	document.getElementById('ssiinstsearch').style.display="inline";
	document.getElementById('ccysearch').style.display="inline";
    
    return true;
}

function AccountWithoutSSI() {
	if(document.getElementById("accountWithoutSSIFlag").checked) {
		document.getElementById("accountWithoutSSI").value="Y";
		document.getElementById('settlementFor').value="";
		document.getElementById('settlementFor').disabled=true;
		document.getElementById('cashSecurityFlag').value="";
		document.getElementById('cashSecurityFlag').disabled=true;
		document.getElementById('marketCode').value="";
		document.getElementById('marketCode').disabled=true;
		document.getElementById('instrumentType').value="";
		document.getElementById('instrumentType').disabled=true;
		document.getElementById('instrumentCode').value="";
		document.getElementById('instrumentCode').disabled=true;
		document.getElementById('settlementCcy').value="";
		document.getElementById('settlementCcy').disabled=true;
		document.getElementById('deliveryMethod').value="";
		document.getElementById('deliveryMethod').disabled=true;
		document.getElementById('ssiStatus').value="";
		document.getElementById('ssiStatus').disabled=true;
		document.getElementById('ssiinstsearch').style.display="none";
		document.getElementById('ccysearch').style.display="none";
	} else {
		document.getElementById("accountWithoutSSI").value="N";
		document.getElementById('settlementFor').disabled=false;
		document.getElementById('cashSecurityFlag').disabled=false;
		document.getElementById('marketCode').disabled=false;
		document.getElementById('instrumentType').disabled=false;
		document.getElementById('instrumentCode').disabled=false;
		document.getElementById('settlementCcy').disabled=false;
		document.getElementById('deliveryMethod').disabled=false;
		document.getElementById('ssiStatus').disabled=false;
		document.getElementById('ssiinstsearch').style.display="inline";
		document.getElementById('ccysearch').style.display="inline";
	}
}

function onloadAccountWithoutSSI(objCombo) {
	if(objCombo.value=="Y") {
		document.getElementById("accountWithoutSSIFlag").checked=true;
	} else {
		document.getElementById("accountWithoutSSIFlag").checked=false;
	}
}