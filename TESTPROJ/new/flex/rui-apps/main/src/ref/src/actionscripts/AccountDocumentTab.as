

import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import flash.events.Event;
import mx.events.FlexEvent;
import mx.utils.StringUtil;
import mx.rpc.events.ResultEvent;
import com.nri.rui.core.controls.XenosAlert;
import mx.events.IndexChangedEvent;
   

[Bindable]public var xml:XML;
[Bindable]private var serviceNameList:ArrayCollection;
[Bindable]private var serviceStatusList:ArrayCollection;
[Bindable]private var serviceContractInfoSummaryResult:ArrayCollection;
[Bindable]private var editMode:Boolean = false;
[Bindable]private var documentInfoSummaryResult:ArrayCollection;
[Bindable]private var urlModeBind:String="Entry";

private static var CP_INTERNAL:String="INTERNAL";
private static var CP_BANKCUST:String="BANK/CUSTODIAN";
private static var CP_BROKER:String="BROKER";

override public function populateRequest():Object{
	var reqObj:Object = new Object();
	reqObj['srcTabNo'] = 3;
	for(var indx:int=0; indx<documentInfoSummaryResult.length; indx++){
		reqObj['legalAgreementDisp[' + indx + '].documentName'] = documentInfoSummaryResult.getItemAt(indx).documentName;
		reqObj['legalAgreementDisp[' + indx + '].agreementDateStr'] = documentInfoSummaryResult.getItemAt(indx).agreementDateStr;
		reqObj['legalAgreementDisp[' + indx + '].receivedDateStr'] = documentInfoSummaryResult.getItemAt(indx).receivedDateStr;
		reqObj['legalAgreementDisp[' + indx + '].documentExecutionDateStr'] = documentInfoSummaryResult.getItemAt(indx).documentExecutionDateStr;
		reqObj['legalAgreementDisp[' + indx + '].expiryDateStr'] = documentInfoSummaryResult.getItemAt(indx).expiryDateStr;
		reqObj['legalAgreementDisp[' + indx + '].dueDays'] = documentInfoSummaryResult.getItemAt(indx).dueDays;
		reqObj['legalAgreementDisp[' + indx + '].receivedFlag'] = documentInfoSummaryResult.getItemAt(indx).receivedFlag;
	}
	return reqObj;
}

/**
 *  Set the url of the dispatch action according to mode,cp detail type and flags
 * */
public function setURLModeBind(xmlObj:XML):void{
	var cpDetailtype:String=xmlObj.account.counterPartyDetailType.toString();
	var counterpartyType:String=xmlObj.account.counterPartyType.toString();
	var reOpenFlag:String=xmlObj.reopenFlag.toString();
	var fromImFundAccountInit:String=xmlObj.fromImFundAccountInit.toString();
	
	if(this.mode=="entry"){
		if(cpDetailtype==CP_INTERNAL){
			urlModeBind="FundEntry";
		}
		else if(cpDetailtype==CP_BANKCUST){
			urlModeBind="BankCustodianEntry";
		}
		else if(cpDetailtype==CP_BROKER){
			urlModeBind="BrokerEntry";
		}
	}
	else if(this.mode=="amend"){
		if(reOpenFlag=="true"){
			urlModeBind="Reopen";
		}
		else{
			urlModeBind="Amend";
		}
	}
	
	else if(this.mode=="copy"){
		if(fromImFundAccountInit=="true"){
			urlModeBind="IMEntry";
		}
		else{
			urlModeBind="Copy";
		}		
	}
	
}

override public function reset():void {
}

override public function initPage(response:XML):void {

	xml = response as XML;
	setURLModeBind(xml);
	var xmlObj:Object = new Object();
	//populate Service Name List
	errPage.removeError();
	serviceNameList = new ArrayCollection();
	serviceNameList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.serviceNameList.item){
		serviceNameList.addItem(xmlObj);
	}
	serviceName.selectedIndex = getIndexOfLabelValueBean(serviceNameList, xml.serviceContractXref.serviceId);
	
	serviceStatusList = new ArrayCollection();
	serviceStatusList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.serviceStatusList.item){
		serviceStatusList.addItem(xmlObj);
	}
	serviceStatus.selectedIndex = getIndexOfLabelValueBean(serviceStatusList, xml.serviceContractXref.serviceStatus);
	
	serviceContractInfoSummaryResult = new ArrayCollection();
	for each( var rec:XML in xml.otherAttributes.serviceContractDispDynaBeansWrapper.item) {
		rec.isVisible = true;
 	    serviceContractInfoSummaryResult.addItem(rec);
    }
    serviceContractInfoSummaryResult.refresh();
	
	documentInfoSummaryResult = new ArrayCollection();
	for each(xmlObj in xml.legalAgreementDispArray.legalAgreementDisp){
		documentInfoSummaryResult.addItem(xmlObj);
	}
	documentInfoSummaryResult.refresh();
}

override public function  validate():ValidationResultEvent{
	
	return new ValidationResultEvent(ValidationResultEvent.VALID);        	
}


/**
 * To add Service Contract Info
 */
private function addServiceContractInfo():void{
	var errorFlag:Boolean = false;
	var errorStr:String = "";
	 if(XenosStringUtils.isBlank(serviceName.text)){
		errorFlag = true;
		errorStr += "Service Id can not be empty";
	}
    if(XenosStringUtils.isBlank(serviceStatus.text)){
		errorFlag = true;
		if(!XenosStringUtils.isBlank(errorStr)){
			errorStr += "\n";
		}
		errorStr += "Service Status can not be empty";
	}
	if(errorFlag){
		XenosAlert.error(errorStr);
		return;
	} 
	editMode = false;
	addServiceContractInfoService.request = populateServiceContractInfo();
//	addServiceContractInfoService.url = "ref/accountDispatch.action?method=addServiceContractXref"
	addServiceContractInfoService.send();
}

/**
 * To edit Service Contract Info
 */        
public function editServiceContractInfo(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.editIndexServiceContractXref = serviceContractInfoSummaryResult.getItemIndex(data);
	/* for each(var obj:Object in serviceContractInfoSummaryResult){
		if(obj.ServiceContractInfoType != "NAM")
			obj.isVisible=true;
	} */
	data.isVisible=false;
	editMode = true;
	serviceContractInfoSummaryResult.refresh();
//	editServiceContractInfoService.url = "ref/accountDispatch.action?method=editServiceContractXref"
	editServiceContractInfoService.request = reqObj;
	editServiceContractInfoService.send();
}

/**
 * To delete Service Contract Info
 */         
public function deleteServiceContractInfo(data:Object):void{
	var reqObj : Object = new Object();
	editMode = false;
	reqObj.editIndexServiceContractXref = serviceContractInfoSummaryResult.getItemIndex(data);
//	deleteServiceContractInfoService.url = "ref/accountDispatch.action?method=deleteServiceContractXref"
	deleteServiceContractInfoService.request = reqObj;
	deleteServiceContractInfoService.send();
}      

/**
 * To save Service Contract Info
 */         
public function saveServiceContractInfo():void{
	var errorFlag:Boolean = false;
	var errorStr:String = "";
	 if(XenosStringUtils.isBlank(serviceName.text)){
		errorFlag = true;
		errorStr += "Service Id can not be empty";
	}
    if(XenosStringUtils.isBlank(serviceStatus.text)){
		errorFlag = true;
		if(!XenosStringUtils.isBlank(errorStr)){
			errorStr += "\n";
		}
		errorStr += "Service Status can not be empty";
	}
	if(errorFlag){
		XenosAlert.error(errorStr);
		return;
	} 
	var reqObj : Object = new Object();
	editMode = false;
//	saveServiceContractInfoService.url = "ref/accountDispatch.action?method=updateServiceContractXref"
	saveServiceContractInfoService.request = populateEditedServiceContractInfo();
	saveServiceContractInfoService.send();
}

/**
 * To cancel the edited Service Contract Info
 */         
private function cancelServiceContractInfo():void{
	var reqObj : Object = new Object();
	editMode = false;
//	cancelEditServiceContractInfoService.url = "ref/accountDispatch.action?method=cancelServiceContractXref"
	cancelEditServiceContractInfoService.request = populateEditedServiceContractInfo();
	cancelEditServiceContractInfoService.send();
}

/**
 * Bind the Service Contract Info to the request object
 */         
private function populateEditedServiceContractInfo():Object{
	var reqObj : Object = new Object();
	reqObj['serviceContractXref.serviceId'] = this.serviceName.selectedItem != null ? this.serviceName.selectedItem.value : "";;
	
	reqObj['serviceContractXref.serviceStatus'] = this.serviceStatus.selectedItem != null ? this.serviceStatus.selectedItem.value : "";;
	
	reqObj['serviceContractXref.contractDateStr'] = this.contractDateStr.text;
	
	reqObj['serviceContractXref.description'] = this.description.text;
	
	return reqObj;
}
        
/**
* This method works as the result handler of the Submit Query Http Services.
* 
*/
public function ServiceContractInfoResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);
    var xmlObjInfo:XML = new XML();
    
	if (null != event) {
		if(rs.child("Errors").length()>0) {
            //some error found
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } 
		 else if(rs.child("otherAttributes").length() > 0){
		 	 var rsAttributes:XML = XML(rs.otherAttributes);
			 if(rsAttributes.child("serviceContractDispDynaBeansWrapper").length()>0) {
				errPage.clearError(event);
				// if(this.mode != "AMEND")
	            serviceContractInfoSummaryResult = new ArrayCollection();
				try {
					var i:int = 0;
				    for each( var rec:XML in rsAttributes.serviceContractDispDynaBeansWrapper.item) {
				    	if(int(rs.editIndexServiceContractXref) == i)
				    		rec.isVisible = false;
				    	else
				    		rec.isVisible = true;
				    	i++;
	 				    serviceContractInfoSummaryResult.addItem(rec);
				    }
				    
				    serviceName.selectedIndex = getIndexOfLabelValueBean(serviceNameList, rs.serviceContractXref.serviceId);
	            	serviceStatus.selectedIndex = getIndexOfLabelValueBean(serviceStatusList, rs.serviceContractXref.serviceStatus);
	            	contractDateStr.text = rs.serviceContractXref.contractDateStr;
	            	description.text = rs.serviceContractXref.description;
	            	serviceContractInfoSummaryResult.refresh();
	            	documentInfoSummaryResult = new ArrayCollection();
					for each(xmlObjInfo in rs.legalAgreementDispArray.legalAgreementDisp){
						documentInfoSummaryResult.addItem(xmlObjInfo);
					}
					documentInfoSummaryResult.refresh();
					if(documentInfoSummaryResult.length>0)
						ws2.opened = true;
					else
						ws2.opened = false;
				}catch(e:Error){
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
			 } 
		 }
		 
		 else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	serviceContractInfoSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}



private function populateServiceContractInfo():Object{
	var reqObj : Object = new Object();
	reqObj['serviceContractXref.serviceId'] = this.serviceName.selectedItem != null ? this.serviceName.selectedItem.value : "";;
	
	reqObj['serviceContractXref.serviceStatus'] = this.serviceStatus.selectedItem != null ? this.serviceStatus.selectedItem.value : "";;
	
	reqObj['serviceContractXref.contractDateStr'] = this.contractDateStr.text;
	
	reqObj['serviceContractXref.description'] = this.description.text;
	
	return reqObj;
}

/**
 * Delete Document Information
 */ 
public function deleteDocumentInfo(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.documentName = data.documentName;
//	deleteDocumentInfoService.url = "ref/accountDispatch.action?method=deleteLegalAggreement"
	deleteDocumentInfoService.request = reqObj;
	deleteDocumentInfoService.send();
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