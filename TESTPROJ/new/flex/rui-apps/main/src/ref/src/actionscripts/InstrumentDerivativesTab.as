

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import flash.events.FocusEvent;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.events.ValidationResultEvent;

import com.nri.rui.ref.validators.InstrumentDeribativesValidator;
//import com.nri.rui.ref.validators.InstrumentDeribativesValidator;

[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]private var xmlResponse:XML = new XML();
[Bindable]private var drvSettlementTypeValues:ArrayCollection=null;
[Bindable]private var optionTypeValues:ArrayCollection=null;
[Bindable]private var callPutFlagValues:ArrayCollection=null;


override public function populateRequest():Object{
	var reqObj:Object = new Object();
	 
	reqObj['instrumentPage.contractStartDateStr'] = this.contractStartDateStr.text;  
	reqObj['instrumentPage.contractExpiryDateStr'] = this.contractExpiryDateStr.text; 
	reqObj['instrumentPage.tickSizeStr'] = this.tickSizeStr.text; 
	reqObj['instrumentPage.underlyingInstrumentCode'] = this.underlyingInstrumentCode.instrumentId.text; 
	reqObj['instrumentPage.drvSettlementType'] = this.drvSettlementType.selectedItem != null ? this.drvSettlementType.selectedItem.value : "";
	var InstrumentType:String = xmlResponse.instrumentPage.instrumentType; 
	if(xmlResponse.instrumentPage.parentInstrumentType == 'OPT'){
		/* || InstrumentType  == 'CO' || InstrumentType == 'BO' ||
            		InstrumentType == 'SO' || InstrumentType == 'IRO'*/
		reqObj['instrumentPage.callPutFlag'] = this.callPutFlag.selectedItem != null ? this.callPutFlag.selectedItem.value : "";
		reqObj['instrumentPage.optionType'] = this.optionType.selectedItem != null ? this.optionType.selectedItem.value : "";
		reqObj['instrumentPage.strikePriceStr'] = this.strikePriceStr.text;  
	}
	if(this.mode == "entry")
		reqObj['SCREEN_KEY'] = 20;
	else 
		reqObj['SCREEN_KEY'] = 25;
	
	return reqObj;
}

override public function  initPage(responseObj:XML):void {
	
	    xmlResponse = responseObj as XML;
	    //set values to fields if they exists
		contractStartDateStr.text = xmlResponse.instrumentPage.contractStartDateStr;
		contractExpiryDateStr.text = xmlResponse.instrumentPage.contractExpiryDateStr;
		tickSizeStr.text = xmlResponse.instrumentPage.tickSizeStr;
		underlyingInstrumentCode.instrumentId.text = xmlResponse.instrumentPage.underlyingInstrumentCode;
		
		
		//populate Settlement type combo
		drvSettlementTypeValues = new ArrayCollection();
		drvSettlementTypeValues.addItem({label: "" , value : ""});
		for each(var xmlObj:Object in xmlResponse.instrumentPage.drvSettlementTypeValues.item){
			drvSettlementTypeValues.addItem(xmlObj);
		}
		drvSettlementTypeValues.refresh();
		drvSettlementType.selectedIndex = getIndexOfLabelValueBean(drvSettlementTypeValues, xmlResponse.instrumentPage.drvSettlementType);
		
		var parentInstrumentType:String = xmlResponse.instrumentPage.parentInstrumentType;
		var InstrumentType:String = xmlResponse.instrumentPage.instrumentType;
		//XenosAlert.info(parentInstrumentType);
		//XenosAlert.info(InstrumentType);
		if(parentInstrumentType == 'OPT'){
            			/*  || InstrumentType == 'CO' || InstrumentType == 'BO' ||
            		InstrumentType == 'SO' || InstrumentType == 'IRO' || InstrumentType == 'BF' || 
            		InstrumentType == 'SIF' || InstrumentType == 'IRF' || InstrumentType == 'CF' || InstrumentType == 'SF' 
            		|| InstrumentType == 'BIF'*/
            			
			optionTypeValues = new ArrayCollection();
			optionTypeValues.addItem({label: "" , value : ""});
			for each(var xmlObj1:Object in xmlResponse.instrumentPage.optionTypeValues.item){
				optionTypeValues.addItem(xmlObj1);
			}
			optionTypeValues.refresh();
			optionType.selectedIndex = getIndexOfLabelValueBean(optionTypeValues, xmlResponse.instrumentPage.optionType);
			
			callPutFlagValues = new ArrayCollection();
			callPutFlagValues.addItem({label: "" , value : ""});
			for each(var xmlObj2:Object in xmlResponse.instrumentPage.callPutFlagValues.item){
				callPutFlagValues.addItem(xmlObj2);
			}
			callPutFlagValues.refresh();
			callPutFlag.selectedIndex = getIndexOfLabelValueBean(callPutFlagValues, xmlResponse.instrumentPage.callPutFlag);
			
			strikePriceStr.text = xmlResponse.instrumentPage.strikePriceStr;
			
			optId.includeInLayout = true;
			optId.visible = true;
			
		} 
		

}

override public function  validate():ValidationResultEvent{
		
		var model:Object = {
							drv:{
								contractStartDateStr:this.contractStartDateStr.text,
								contractExpiryDateStr:this.contractExpiryDateStr.text
								
	                		}
		                	}; 
		
		
		/*
		 * ,
								parentInstrumentType: xmlResponse.instrumentPage.parentInstrumentType != null? xmlResponse.instrumentPage.parentInstrumentType:xmlResponse.instrumentPage.instrumentType
								tickSizeStr:this.tickSizeStr.text,
								drvSettlementType:this.drvSettlementType.selectedItem != null ? this.drvSettlementType.selectedItem.value : "",
								callPutFlag:this.callPutFlag.selectedItem != null ? this.callPutFlag.selectedItem.value : "",
								optionType:this.optionType.selectedItem != null ? this.optionType.selectedItem.value : "",
								strikePriceStr:this.strikePriceStr.text,
		 */
		var validator:InstrumentDeribativesValidator = new InstrumentDeribativesValidator();
		validator.source = model;
		validator.property = "drv";
		var validationResult:ValidationResultEvent = validator.validate(); 
		return validationResult;    	
}

private function validateNumber(event:FocusEvent):void{
	numVal1.source = TextInput(event.currentTarget);
	numVal1.handleNumericField(numberFormatter);
}

private function validateNumber2(event:FocusEvent):void{
	numVal2.source = TextInput(event.currentTarget);
	numVal2.handleNumericField(numberFormatter);
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