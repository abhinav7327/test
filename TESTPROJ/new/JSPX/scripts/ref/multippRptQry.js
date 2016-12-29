//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $





function putParameterValues(){
	var str = "";
	var validationMessages = [];
	var msg = "";
	var isOptional = ""; 
	var eleUIType = "";
	for(var i = 0; i < elementIdList.length; i++){
		strValue = "optionValuesMap['"+elementIdList[i]+"-"+elementTypeList[i]+"']";
		eleUIType = elementUITypeList[i];
		if(eleUIType != ""){
			eleUIType = eleUIType.substr(1);
		}
		str = str + elementNameList[i] + "," + elementIdList[i] + ","+ document.getElementsByName(strValue)[0].value +  "," + eleUIType + "," + elementOptionalList[i] + ",\n";
	}
	document.getElementById('parameterValueStrForRUI').value = str;
	return true;
	
}

var resetActionFuncSelect = function(){
	var form =  $('#queryForm',"#content");
	form.attr('resetAction',$('#reqUrlSelect').attr('value'));	
}

var resetActionFuncUI = function(){
	var form =  $('#queryForm',"#content");
	form.attr('resetAction',$('#reqUrlUI').attr('value'));	
}
