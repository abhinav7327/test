// ActionScript file
import com.nri.rui.core.controls.XenosAlert;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import flash.system.System;
import flash.system.Security;
import flash.events.Event;
import mx.events.FlexEvent;
import mx.managers.IPopUpManager;
import mx.managers.PopUpManager;
import mx.controls.DateField;
import mx.controls.ComboBox;
import mx.rpc.events.ResultEvent;
import com.nri.rui.core.utils.XenosStringUtils;
   
   			
 private var iPopUpManager:IPopUpManager;

[Bindable]private var agencyFlagValueList:ArrayCollection;
[Bindable]private var poolTypeList:ArrayCollection;
[Bindable]private var cmoTypeList:ArrayCollection;
[Bindable]private var cmoTypeSummaryList:ArrayCollection = new ArrayCollection();
[Bindable]private var factorySummaryList:ArrayCollection = new ArrayCollection();
[Bindable]public var xmlResponse:XML;


override public function populateRequest():Object{
	var reqObj:Object = new Object();
	reqObj['instrumentPage.agencyFlag'] = agencyFlag.selectedItem != null ? agencyFlag.selectedItem.value : "";
	reqObj['instrumentPage.poolType'] = poolType.selectedItem != null ? poolType.selectedItem.value : "";
	reqObj['instrumentPage.poolResetDateStr'] = poolResetDate.text;
	//reqObj['instrumentPage.cmoType'] = redmpnPrice.text;
	if(this.mode == "entry")
		reqObj['SCREEN_KEY'] = 20;
	else 
		reqObj['SCREEN_KEY'] = 25;
	
	return reqObj;
}

override public function reset():void {
}

override public function  initPage(responseObj:XML):void {
	//trace("initPage1 :: " + this);
	xmlResponse = responseObj as XML;
	
	//populate agency flag combo
		agencyFlagValueList = new ArrayCollection();
		for each(var xmlObj:Object in xmlResponse.instrumentPage.agencyFlagValues.item){
			agencyFlagValueList.addItem(xmlObj);
		}
		agencyFlag.selectedIndex = getIndexOfLabelValueBean(agencyFlagValueList, xmlResponse.instrumentPage.agencyFlag);
	//populate pool type combo
		poolTypeList = new ArrayCollection();
		poolTypeList.addItem({label:" ", value:" "});
		for each(var xmlObjPD:Object in xmlResponse.instrumentPage.poolTypeValues.item){
			poolTypeList.addItem(xmlObjPD);
		}
		poolType.selectedIndex = getIndexOfLabelValueBean(poolTypeList, xmlResponse.instrumentPage.poolType);
	//populate pool reset date
		this.poolResetDate.text = xmlResponse.instrumentPage.poolResetDateStr;
	//populate cmo type combo
		cmoTypeList = new ArrayCollection();
		cmoTypeList.addItem({label:" ", value:" "});
		for each(var xmlObjCMO:Object in xmlResponse.instrumentPage.cmoTypeValues.item){
			cmoTypeList.addItem(xmlObjCMO);
		}
		cmoType.selectedIndex = getIndexOfLabelValueBean(cmoTypeList, xmlResponse.instrumentPage.cmoType);
		
		cmoTypeSummaryList = new ArrayCollection();
		for each(var xmlObjTF:XML in xmlResponse.instrumentPage.cmoTypesWrapper.item){
			cmoTypeSummaryList.addItem(xmlObjTF);
		}
		
		factorySummaryList = new ArrayCollection();
		for each(var xmlObjTF:XML in xmlResponse.factorsWrapper.factors){
			xmlObjTF.isVisible = true;
			factorySummaryList.addItem(xmlObjTF);
		}		
		 dateFrom.text=xmlResponse.factorDateFrom.toString();
		 recordDate.text=xmlResponse.factorRecordDate.toString();
}

override public function  validate():ValidationResultEvent{
	
	return new ValidationResultEvent(ValidationResultEvent.VALID);        	
} 


//******** For Cmo Type Grid

/**
 * To add Cmo Type
 */
private function addCmoType():void{
	if(XenosStringUtils.isBlank(cmoType.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.cmotype'));
		return;
	}
	addCmoTypeService.request = populateCmoType();
	if(this.mode == "amend")
		addCmoTypeService.url = "ref/instrumentAmendDispatch.action?method=addCmoType"
	else 
		addCmoTypeService.url = "ref/instrumentEntryDispatch.action?method=addCmoType"
	addCmoTypeService.send();
}

 public function deleteCmoType(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = cmoTypeSummaryList.getItemIndex(data);
	if(this.mode == "amend")
		deleteCmoTypeService.url = "ref/instrumentAmendDispatch.action?method=deleteCmoType"
	else 
		deleteCmoTypeService.url = "ref/instrumentEntryDispatch.action?method=deleteCmoType"
	deleteCmoTypeService.request = reqObj;
	deleteCmoTypeService.send();
}



/**
* This method works as the result handler of the Submit Query Http Services.
* 
*/
public function CmoTypeResult(event:ResultEvent):void {
//    var rsAll:XML = XML(event.result);
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("Errors").length()>0) {
            //some error found
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	//trace("rs :: " + rs);
			errPage.clearError(event);
        	cmoTypeSummaryList.removeAll(); 
			try {
			    for each ( var rec:XML in rs.instrumentPage.cmoTypesWrapper.item ) {
			    	//rec.isVisible = true;
 				    cmoTypeSummaryList.addItem(rec);
			    }
            	cmoType.selectedIndex=0;
            	cmoTypeSummaryList.refresh();
			}catch(e:Error){
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
   		 }
	 }
    
}


private function populateCmoType():Object{
	var reqObj : Object = new Object();
	reqObj['instrumentPage.cmoType'] = this.cmoType.selectedItem != null ? this.cmoType.selectedItem.value : "";
	return reqObj;
}


//********* For Factor Grid

/**
 * To add Factor Information
 */
private function addFactor():void{
	/* if(XenosStringUtils.isBlank(categoryType.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.categorytype'));
		return;
	}else if(XenosStringUtils.isBlank(categoryId.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.categoryid'));
		return;
	} */
	addFactorService.request = populateFactor();
	if(this.mode == "amend")
		addFactorService.url = "ref/instrumentAmendDispatch.action?method=addFactor"
	else 
		addFactorService.url = "ref/instrumentEntryDispatch.action?method=addFactor"
	addFactorService.send();
}

public function editFactor(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = factorySummaryList.getItemIndex(data);
	factorySummaryList.removeItemAt(reqObj.rowNo);
	//data.isVisible=false;
	factorySummaryList.refresh();
	/* if(this.mode == "AMEND")
		editInstrumentCodeService.url = "ref/countryAmendDispatch.action?method=editCountryCodeInfo"
	else */
	if(this.mode == "amend")
		editFactorService.url = "ref/instrumentAmendDispatch.action?method=editFactor"
	else 
		editFactorService.url = "ref/instrumentEntryDispatch.action?method=editFactor"
	editFactorService.request = reqObj;
	editFactorService.send();
}

 public function deleteFactor(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = factorySummaryList.getItemIndex(data);
	/* if(this.mode == "AMEND")
		deleteInstrumentCodeService.url = "ref/countryAmendDispatch.action?method=deleteCountryCodeInfo"
	else */
	if(this.mode == "amend")
		deleteFactorService.url = "ref/instrumentAmendDispatch.action?method=deleteFactor"
	else 
		deleteFactorService.url = "ref/instrumentEntryDispatch.action?method=deleteFactor"
	deleteFactorService.request = reqObj;
	deleteFactorService.send();
}



/**
* This method works as the result handler of the Submit Query Http Services.
* 
*/
public function FactorResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		 if(rs.child("factorsWrapper").length()>0) {
		 	//trace("factorsWrapper" + rs.factorsWrapper);
			errPage.clearError(event);
			// if(this.mode != "AMEND")
            	factorySummaryList.removeAll(); 
			try {
			    for each ( var rec:XML in rs.factorsWrapper.factors ) {
			    	//trace("factors" + rec);
			    	rec.isVisible = true;
 				    factorySummaryList.addItem(rec);
			    }
            	factorySummaryList.refresh();
            	poolFactor.text = "";
				poolBalance.text = "";
				dateFrom.text = "";
				recordDate.text = "";
			}catch(e:Error){
			    //XenosAlert.error(e.toString() + e.message);
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } else if(rs.child("Errors").length()>0) {
            //some error found
		 	//countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	factorySummaryList.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
    
}

/**
* This method works as the result handler of the Submit Query Http Services.
* 
*/
public function FactorEditResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		if(rs.child("factorsWrapper").length()>0){
			poolFactor.text = rs.poolFactor;
			poolBalance.text = rs.poolBalance;
			dateFrom.text = rs.factorDateFrom;
			recordDate.text = rs.factorRecordDate;
		} else if(rs.child("Errors").length()>0) {
            //some error found
		 	factorySummaryList.removeAll(); // clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	factorySummaryList.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
    
}

private function populateFactor():Object{
	var reqObj : Object = new Object();
	reqObj['poolFactor'] = this.poolFactor.text;
	reqObj['poolBalance'] = this.poolBalance.text;
	reqObj['factorDateFrom'] = this.dateFrom.text;
	reqObj['factorRecordDate'] = this.recordDate.text;
	return reqObj;
}

/* private function validateNumber(event:FocusEvent):void{
	numVal1.source = TextInput(event.currentTarget);
	numVal1.handleNumericField(numberFormatter);
} */

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
