

import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.ref.validators.AccountContractValidator;
//import com.nri.rui.ref.validators.AccountContractValidator;
import com.nri.rui.core.Globals;

[Bindable]public var xml:XML;
private var contractCountryName:String;


/*
 * if (viewOption == 'AMEND'){
 	if(reopenFlag == 'false'){
      	submit: onValidate="document.forms[0].action='accountQueryDispatch.action?'" action="method=backToQueryResult&modeOfOperation=AMEND"
 	}else {
 		submit: onValidate="document.forms[0].action='accountQueryDispatch.action?'" action="method=backToQueryResult&modeOfOperation=REOPEN"
	}
	}
	if (viewOption == 'COPY'){
         submit: onValidate="document.forms[0].action='accountQueryDispatch.action?'" action="method=backToQueryResult&modeOfOperation=COPY" 
   }
                
    submit: action="method=submitAccountEntry"
    if (viewOption == 'ENTRY'){
          reset: action="method=resetAccountEntry"
    }
    if (viewOption == 'AMEND'){
		reset" action="method=resetAccountAmend"
    }
	if (viewOption == 'COPY'){
		reset: action="method=resetAccountCopy"
	}
 */
override public function populateRequest():Object{
	var reqObj:Object = new Object();

	reqObj['contractAddress.building'] = this.building.text;
 	reqObj['contractAddress.street'] = this.street.text;
 	reqObj['contractAddress.city'] = this.city.text;
 	reqObj['contractAddress.countryCode'] = this.country.countryCode.text;
 	reqObj['contractAddress.state'] = this.state.stateCode.text;
 	reqObj['contractAddress.postalCode'] = this.postalCode.text;
 	reqObj['contractAddress.addressOwnerName1'] = this.addressOwnerName1.text;
 	reqObj['contractAddress.addressOwnerName2'] = this.addressOwnerName2.text;
 	reqObj['contractAddress.addressOwnerName3'] = this.addressOwnerName3.text;
 	reqObj['contractAddress.addressOwnerName4'] = this.addressOwnerName4.text;
 	reqObj['srcTabNo'] = 2;
	return reqObj;
}

override public function reset():void {
}

override public function initPage(response:XML):void {

	xml = response as XML;
	//XenosAlert.info(xml.toXMLString());
	this.building.text = xml.contractAddress.building;
 	this.street.text = xml.contractAddress.street;
 	this.city.text = xml.contractAddress.city;
 	this.country.countryCode.text = xml.contractAddress.countryCode;
 	this.state.stateCode.text = xml.contractAddress.state;
 	this.postalCode.text = xml.contractAddress.postalCode;
 	this.addressOwnerName1.text = xml.contractAddress.addressOwnerName1;
 	this.addressOwnerName2.text = xml.contractAddress.addressOwnerName2;
 	this.addressOwnerName3.text = xml.contractAddress.addressOwnerName3;
 	this.addressOwnerName4.text = xml.contractAddress.addressOwnerName4;
	
}

override public function  validate():ValidationResultEvent{
	
	var model:Object = {
							contract:{
								stateStr:this.state.stateCode.text
								
	                		}
		                	}; 
		
		
		
		var validator:AccountContractValidator = new AccountContractValidator();
		validator.source = model;
		validator.property = "contract";
		var validationResult:ValidationResultEvent = validator.validate(); 
		return validationResult;        	
}

/**
 * Calculates the index of a label value bean given its value, within a given 
 * array collection of such beans.
 * Returns 0 if the value is null or empty string.
 */
private function getIndexOfLabelValueBean(collection:ArrayCollection, value:String):int {
	var index:int = 0;
	if (value == null || value == XenosStringUtils.EMPTY_STR) {
		return index;
	}
	for (var count:int = 0; count < collection.length; count++) {
		var bean:Object = collection.getItemAt(count);
		if (bean['value'] == value) {
			index = count;
			break;
		}
	}
	return index;
}

/**
 * Calculates the index of an item, within a given 
 * array collection.
 * Returns 0 if the value is null or empty string.
 */
private function getIndex(collection:ArrayCollection, value:String):int {
	var index:int = 0;
	if (value == null || value == XenosStringUtils.EMPTY_STR) {
		return index;
	}
	for (var count:int = 0; count < collection.length; count++) {
		if (String(collection.getItemAt(count)) == value) {
			index = count;
			break;
		}
	}
	return index;
}

public function getCountry():ArrayCollection{
	var country:Array = new Array();
	country["countryCode"] = this.country.countryCode.text;
	return new ArrayCollection(country);
}
