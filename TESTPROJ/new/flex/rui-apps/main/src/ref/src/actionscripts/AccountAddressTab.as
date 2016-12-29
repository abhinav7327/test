

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
   
var xmlObj:Object=new Object();

private static var CP_INTERNAL:String="INTERNAL";
private static var CP_BANKCUST:String="BANK/CUSTODIAN";
private static var CP_BROKER:String="BROKER";

[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]public var xmlResponse:XML;

[Bindable]private var reportNameList:ArrayCollection;
[Bindable]private var groupReportNameList:ArrayCollection;
[Bindable]private var tradeTypeList:ArrayCollection;
[Bindable]private var delivAddressIdList:ArrayCollection;
[Bindable]private var addressTypeList:ArrayCollection;
[Bindable]private var addressIdList:ArrayCollection;
[Bindable]private var returnedStatusList:ArrayCollection;
[Bindable]private var urlModeBind:String="Entry";

[Bindable]private var deliveryAddressRuleSummaryResult:ArrayCollection=new ArrayCollection();
[Bindable]public var addressSummaryResult:ArrayCollection=new ArrayCollection();


override public function populateRequest():Object{
	var reqObj:Object = new Object();
	
	return reqObj;
}

override public function reset():void {
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

override public function initPage(response:XML):void {

	xmlResponse = response as XML;
	setURLModeBind(xmlResponse);
	
	reportNameList = new ArrayCollection();
	reportNameList.addItem({label: " " , value : " "});
	for each(xmlObj in xmlResponse.dropDownListValues.addressReportIdList.item){
		reportNameList.addItem(xmlObj);
	}
	
	groupReportNameList = new ArrayCollection();
	groupReportNameList.addItem(" ");
	for each(xmlObj in xmlResponse.dropDownListValues.addressReportGroupIdList.addressReportGroupId){
		groupReportNameList.addItem(xmlObj);
	}
	
	tradeTypeList = new ArrayCollection();
	tradeTypeList.addItem(" ");
	for each(xmlObj in xmlResponse.dropDownListValues.tradeTypeList.tradeType){
		tradeTypeList.addItem(xmlObj);
	}
	
	delivAddressIdList = new ArrayCollection();
	delivAddressIdList.addItem(" ");
	for each(xmlObj in xmlResponse.dropDownListValues.delivAddressIdList.delivAddressId){
		delivAddressIdList.addItem(xmlObj);
	}
	
	addressTypeList = new ArrayCollection();
	addressTypeList.addItem({label: " " , value : " "});
	for each(xmlObj in xmlResponse.dropDownListValues.addressTypeList.item){
		addressTypeList.addItem(xmlObj);
	}
	
	//for second grid
	addressIdList = new ArrayCollection();
	addressIdList.addItem({label: " " , value : " "});
	for each(xmlObj in xmlResponse.dropDownListValues.addressIdList.item){
		addressIdList.addItem(xmlObj);
	}
	
	returnedStatusList = new ArrayCollection();
	returnedStatusList.addItem({label: " " , value : " "});
	for each(xmlObj in xmlResponse.dropDownListValues.returnStatusList.item){
		returnedStatusList.addItem(xmlObj);
	}
	
	setDeliveryAddressRuleResult(xmlResponse);
	setAddressEditResult(xmlResponse);
	
	//for reset
	resetDelivAddressRule();
	resetAddress(); 
	
	//Account no
	accountNo.text = xmlResponse.accountNoExp;
	
	//Instrument Code type 
	accountName.text = xmlResponse.shortNameExp;
	
	//have to populate from Form
	for each ( var rec:XML in xmlResponse.otherAttributes.addressRuleDispDynaBeansWrapper.item) {
		rec.isVisible = true;
   		deliveryAddressRuleSummaryResult.addItem(rec);
 	}
	for each ( var rec:XML in xmlResponse.otherAttributes.addressDispDynaBeansWrapper.item) {
		rec.isVisible = true;
		addressSummaryResult.addItem(rec);
	}

}

override public function  validate():ValidationResultEvent{
	
	return new ValidationResultEvent(ValidationResultEvent.VALID);        	
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


	//for first grid
	private function resetDelivAddressRule():void{
		reportName.selectedIndex=0;
		groupReportName.selectedIndex=0;
		tradeType.selectedIndex=0;
		market.itemCombo.selectedIndex=0;
		instrumentType.itemCombo.selectedIndex=0;
		addressRuleId.selectedIndex=0;
		addressType.selectedIndex=0;
		deliveryAddressRuleSummaryResult.removeAll();
	}

	/**
	 * To add Delivery Address Rule Information
	 */
	private function addDeliveryAddressRule():void{
		if(XenosStringUtils.isBlank(reportName.text) && XenosStringUtils.isBlank(groupReportName.text) || 
				!XenosStringUtils.isBlank(reportName.text) && !XenosStringUtils.isBlank(groupReportName.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.reportid'));
			return;
		}else if(XenosStringUtils.isBlank(addressRuleId.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.addressid'));
			return;
		}else if(XenosStringUtils.isBlank(addressType.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.addresstype'));
			return;
		}
		var reqObj : Object = new Object();
		reqObj.method="addDeliveryAddressRule";
		reqObj.srcTabNo = 4;
		actDeliveryAddressRule.request = populateDeliveryAddressRule(reqObj);
		actDeliveryAddressRule.send();
	}

	public function editDeliveryAddressRule(data:Object):void{
		
		addAddressRuleBtn.visible=false;
		saveAddressRuleBtn.visible=true;
		cancelAddressRuleBtn.visible=true;
//		editDeliveryAddressResult();
		
		var reqObj : Object = new Object();
		reqObj.editIndexDeliveryAddress = deliveryAddressRuleSummaryResult.getItemIndex(data);
		reqObj.method="editDeliveryAddressRule";
		reqObj.srcTabNo = 4;
		actDeliveryAddressRule.request = reqObj;
		actDeliveryAddressRule.send();
	}

	public function deleteDeliveryAddressRule(data:Object):void{
		var reqObj : Object = new Object();
		reqObj.editIndexDeliveryAddress = deliveryAddressRuleSummaryResult.getItemIndex(data);
		reqObj.method="deleteDeliveryAddressRule";
		reqObj.srcTabNo = 4;
		actDeliveryAddressRule.request = reqObj;
		actDeliveryAddressRule.send();
	}

	private function saveDeliveryAddressRule():void{
		if(XenosStringUtils.isBlank(reportName.text) && XenosStringUtils.isBlank(reportName.text) || 
				!XenosStringUtils.isBlank(reportName.text) && !XenosStringUtils.isBlank(groupReportName.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.reportid'));
			return;
		}else if(XenosStringUtils.isBlank(addressRuleId.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.addressid'));
			return;
		}else if(XenosStringUtils.isBlank(addressType.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.addresstype'));
			return;
		}
		addAddressRuleBtn.visible=true;
		saveAddressRuleBtn.visible=false;
		cancelAddressRuleBtn.visible=false;
		
		var reqObj : Object = new Object();
		reqObj.method="updateDeliveryAddressRule";
		reqObj.srcTabNo = 4;
		actDeliveryAddressRule.request = populateDeliveryAddressRule(reqObj);
		actDeliveryAddressRule.send();
	}
	
	private function cancelDeliveryAddressRule():void{
		addAddressRuleBtn.visible=true;
		saveAddressRuleBtn.visible=false;
		cancelAddressRuleBtn.visible=false;
		
		var reqObj : Object = new Object();
		reqObj.method="cancelDeliveryAddressRule";
		reqObj.srcTabNo = 4;
		actDeliveryAddressRule.request = populateDeliveryAddressRule(reqObj);
		actDeliveryAddressRule.send();
	}

		// Called Result Handler for Add/Delete/Save/Cancel
	private function handleDeliveryAccountAddressEvent(event:ResultEvent):void{
		var addXml:XML = XML(event.result);
		if (addXml!= null) {
			xmlResponse=addXml;
	     if(xmlResponse.child("Errors").length()>0){
        	var errList:ArrayCollection = convertErrorToArray(xmlResponse);
        	if(errList.length>0){
          	  errPage.showError(errList);
        	}
		}else{
			// Initialize Page with values
			populateDeliveryAddressResultRuleTable(xmlResponse);
			setDeliveryAddressRuleResult(xmlResponse);
//			resetDelivAddressRule();
			errPage.clearError(event);
			}
      	}
	}
	
	private function populateDeliveryAddressResultRuleTable(xmlObj:XML):void{
		deliveryAddressRuleSummaryResult = new ArrayCollection();
		var indx1:int = 0; 
		 for each ( var rec:XML in xmlObj.otherAttributes.addressRuleDispDynaBeansWrapper.item) {
	    	 if(xmlObj.editIndexDeliveryAddress == indx1){
			  	 	rec.isVisible=false;
			   }else{
			   		rec.isVisible=true;
			   }
 			    deliveryAddressRuleSummaryResult.addItem(rec);
 			    indx1++; 
		 }
		
	}
	
	private function setDeliveryAddressRuleResult(rs:XML):void{
		reportName.selectedIndex = getIndexOfLabelValueBean(reportNameList,rs.delivAddressRule.reportId);
		groupReportName.selectedIndex = getIndex(groupReportNameList,rs.delivAddressRule.reportGroupId);
		tradeType.selectedIndex = getIndex(tradeTypeList,rs.delivAddressRule.tradeTypePk);
		market.itemCombo.text = rs.delivAddressRule.finInstRoleCode.toString();;
		instrumentType.itemCombo.text = rs.delivAddressRule.instrumentType.toString();
		addressRuleId.selectedIndex = getIndex(delivAddressIdList,rs.delivAddressRule.addressId);
		addressType.selectedIndex = getIndexOfLabelValueBean(addressTypeList,rs.delivAddressRule.addressType);
	}

	private function populateDeliveryAddressRule(reqObj:Object):Object{
		
		reqObj['delivAddressRule.reportId'] = this.reportName.selectedItem != null ? this.reportName.selectedItem.value : "";
		reqObj['delivAddressRule.reportGroupId'] = this.groupReportName.selectedItem != null ? this.groupReportName.selectedItem.toString() : "";
		reqObj['delivAddressRule.tradeTypePk'] = this.tradeType.selectedItem != null ? this.tradeType.selectedItem.toString() : "";
		reqObj['delivAddressRule.finInstRoleCode'] = this.market.itemCombo != null ? this.market.itemCombo.text : "" ;
		reqObj['delivAddressRule.instrumentType'] = this.instrumentType.itemCombo != null ? this.instrumentType.itemCombo.text : "" ;
		reqObj['delivAddressRule.addressId'] = this.addressRuleId.selectedItem != null ? this.addressRuleId.selectedItem.toString() : "";
		reqObj['delivAddressRule.addressType'] = this.addressType.selectedItem != null ? this.addressType.selectedItem.value : "";
		
		return reqObj;
	}
	
	//for second grid
	private function resetAddress():void{
		addressId.selectedIndex=0;
		building.text = XenosStringUtils.EMPTY_STR;
		street.text = XenosStringUtils.EMPTY_STR;
		city.text = XenosStringUtils.EMPTY_STR;
		countryCodeForCcy.countryCode.text = XenosStringUtils.EMPTY_STR;
		stateAndCountry.text = XenosStringUtils.EMPTY_STR; 
		postalCode.text = XenosStringUtils.EMPTY_STR;
		ownername1.text = XenosStringUtils.EMPTY_STR; 
		ownername2.text = XenosStringUtils.EMPTY_STR;
		ownername3.text = XenosStringUtils.EMPTY_STR; 
		ownername4.text = XenosStringUtils.EMPTY_STR;
		addressSummaryResult.removeAll();
	}

	/**
	 * To add Address Information
	 */
	private function addAddress():void{
	
		if(XenosStringUtils.isBlank(addressId.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.addressid'));
			return;
		}else if(XenosStringUtils.isBlank(building.text) 
					&& XenosStringUtils.isBlank(street.text) && XenosStringUtils.isBlank(city.text) 
					&& XenosStringUtils.isBlank(countryCodeForCcy.countryCode.text) && XenosStringUtils.isBlank(stateAndCountry.text) 
					&& XenosStringUtils.isBlank(postalCode.text) && XenosStringUtils.isBlank(ownername1.text) 
					&& XenosStringUtils.isBlank(ownername2.text) && XenosStringUtils.isBlank(ownername3.text) 
					&& XenosStringUtils.isBlank(ownername4.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.oneaddridstatus'));
			return;
		}
		var reqObj : Object = new Object();
		reqObj.method = "addDeliveryAddress";
		reqObj.srcTabNo = 4;
		actAddressService.request = populateAddress(reqObj);
		actAddressService.send();
	}
	
	public function editAddress(data:Object):void{
		
		addAddressBtn.visible=false;
		saveAddressBtn.visible=true;
		cancelAddressBtn.visible=true;
//		setAddressEditResult();
		
		var reqObj : Object = new Object();
		reqObj.editIndexAddress = addressSummaryResult.getItemIndex(data);
		reqObj.method="editDeliveryAddress";
		reqObj.srcTabNo = 4;
		addressSummaryResult.refresh();
		actAddressService.request = reqObj;
		actAddressService.send();
	}
	
	public function deleteAddress(data:Object):void{
		var reqObj : Object = new Object();
		reqObj.method="deleteDeliveryAddress";
		reqObj.srcTabNo = 4;
		reqObj.editIndexAddress = addressSummaryResult.getItemIndex(data);
		actAddressService.request = reqObj;
		actAddressService.send();
	}
	
	private function saveAddress():void{
		
		if(XenosStringUtils.isBlank(addressId.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.addressid'));
			return;
		}else if(XenosStringUtils.isBlank(building.text) && XenosStringUtils.isBlank(street.text) 
					&& XenosStringUtils.isBlank(city.text) && XenosStringUtils.isBlank(countryCodeForCcy.countryCode.text) 
					&& XenosStringUtils.isBlank(stateAndCountry.text) && XenosStringUtils.isBlank(postalCode.text) 
					&& XenosStringUtils.isBlank(ownername1.text) && XenosStringUtils.isBlank(ownername2.text) 
					&& XenosStringUtils.isBlank(ownername3.text) && XenosStringUtils.isBlank(ownername4.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.oneaddridstatus'));
			return;
		}
		addAddressBtn.visible=true;
		saveAddressBtn.visible=false;
		cancelAddressBtn.visible=false;
		
		var reqObj : Object = new Object();
		reqObj.method="updateDeliveryAddress";
		reqObj.srcTabNo = 4;
		actAddressService.request = populateAddress(reqObj);
		actAddressService.send();
	}
	
	private function cancelAddress():void{
		addAddressBtn.visible=true;
		saveAddressBtn.visible=false;
		cancelAddressBtn.visible=false;
		
		var reqObj : Object = new Object();
		reqObj.method="cancelDeliveryAddress";
		reqObj.srcTabNo = 4;	
		actAddressService.request = populateAddress(reqObj);
		actAddressService.send();
	}
	
	
	// Called Result Handler for Add/Delete/Save/Cancel
	private function handleAccountAddressEvent(event:ResultEvent):void{
		var addXml:XML = XML(event.result);
		if (addXml!= null) {
			xmlResponse=addXml;
	     if(xmlResponse.child("Errors").length()>0){
        	var errList:ArrayCollection = convertErrorToArray(xmlResponse);
        	if(errList.length>0){
          	  errPage.showError(errList);
        	}
		}else{
			// Initialize Page with values
			populateAddressResultTable(xmlResponse);
			setAddressEditResult(xmlResponse);
			//for populate address id of first grid
			delivAddressIdList = new ArrayCollection();
			delivAddressIdList.addItem(" ");
			for each(xmlObj in xmlResponse.dropDownListValues.delivAddressIdList.delivAddressId){
				delivAddressIdList.addItem(xmlObj);
			}
//			resetAddress();
			errPage.clearError(event);
			}
      	}
	}

	private function populateAddressResultTable(xmlObj:XML):void{
		addressSummaryResult = new ArrayCollection();
		var index2:int = 0; 
		 for each ( var rec:XML in xmlObj.otherAttributes.addressDispDynaBeansWrapper.item) {
	    	 if(xmlObj.editIndexAddress == index2){
			  	 	rec.isVisible=false;
			   }else{
			   		rec.isVisible=true;
			   }
 			    addressSummaryResult.addItem(rec);
 			    index2++; 
		 }
		
	}
	
        // Convert the Error into Error Array
   	 private function convertErrorToArray(tempXmlObj:XML):ArrayCollection{
		var errList:ArrayCollection	= new ArrayCollection();
			for each (var rec:String in tempXmlObj.Errors.error) {					    	
		 	   errList.addItem(rec);		 				    
	  	    }
		   return errList;
     }
		
		
	private function setAddressEditResult(rs:XML):void{
		addressId.selectedIndex = getIndexOfLabelValueBean(addressIdList,rs.address.addressId);
		returnedStatus.selectedIndex = getIndexOfLabelValueBean(returnedStatusList,rs.address.returnedStatusExp);
		building.text = rs.address.building.toString();
		street.text = rs.address.street.toString();
		city.text = rs.address.city.toString();
		countryCodeForCcy.countryCode.text = rs.address.countryCode.toString();
		stateAndCountry.text = rs.address.countryCode.toString();
		postalCode.text = rs.address.postalCode.toString();
		ownername1.text = rs.address.addressOwnerName1.toString();
		ownername2.text = rs.address.addressOwnerName2.toString();
		ownername3.text = rs.address.addressOwnerName3.toString();
		ownername4.text = rs.address.addressOwnerName4.toString();
	}

	private function populateAddress(reqObj:Object):Object{
		
		reqObj['address.addressId'] = this.addressId.selectedItem != null ? this.addressId.selectedItem.value : "";
		reqObj['address.returnedStatus'] = this.returnedStatus.selectedItem != null ? this.returnedStatus.selectedItem.value : "";
		reqObj['address.building'] = this.building.text != null ? this.building.text : "";
		reqObj['address.street'] = this.street.text != null ? this.street.text : "";
		reqObj['address.city'] = this.city.text != null ? this.city.text : "";
		reqObj['address.countryCode'] = this.countryCodeForCcy.countryCode.text != null ? this.countryCodeForCcy.countryCode.text : "";
		reqObj['address.state'] = this.stateAndCountry.text != null ? this.stateAndCountry.text : "";
		reqObj['address.postalCode'] = this.postalCode.text != null ? this.postalCode.text : "";
		reqObj['address.addressOwnerName1'] = this.ownername1.text != null ? this.ownername1.text : "";
		reqObj['address.addressOwnerName2'] = this.ownername2.text != null ? this.ownername2.text : "";
		reqObj['address.addressOwnerName3'] = this.ownername3.text != null ? this.ownername3.text : "";
		reqObj['address.addressOwnerName4'] = this.ownername4.text != null ? this.ownername4.text : "";
	
		return reqObj;
	}
	
	public function loadMarket():void{
		var req:Object = new Object();
		
	//	req.method="loadDefaultMarket";
		req.parameter="ADDRESS";
		req['srcTabNo'] = '4';
		req['delivAddressRule.reportId'] = this.reportName.selectedItem != null ? this.reportName.selectedItem.value : "";
		req['delivAddressRule.reportGroupId'] = this.groupReportName.selectedItem != null ? this.groupReportName.selectedItem.toString() : "";
		req['delivAddressRule.tradeTypePk'] = this.tradeType.selectedItem != null ? this.tradeType.selectedItem.toString() : "";
		req['delivAddressRule.finInstRoleCode'] = this.market.itemCombo != null ? this.market.itemCombo.text : "" ;
		req['delivAddressRule.instrumentType'] = this.instrumentType.itemCombo != null ? this.instrumentType.itemCombo.text : "" ;
		req['delivAddressRule.addressId'] = this.addressRuleId.selectedItem != null ? this.addressRuleId.selectedItem.toString() : "";
		req['delivAddressRule.addressType'] = this.addressType.selectedItem != null ? this.addressType.selectedItem.value : "";
		
		req['address.addressId'] = this.addressId.selectedItem != null ? this.addressId.selectedItem.value : "";
		req['address.returnedStatus'] = this.returnedStatus.selectedItem != null ? this.returnedStatus.selectedItem.value : "";
		req['address.building'] = this.building.text != null ? this.building.text : "";
		req['address.street'] = this.street.text != null ? this.street.text : "";
		req['address.city'] = this.city.text != null ? this.city.text : "";
		req['address.countryCode'] = this.countryCodeForCcy.countryCode.text != null ? this.countryCodeForCcy.countryCode.text : "";
		req['address.state'] = this.stateAndCountry.text != null ? this.stateAndCountry.text : "";
		req['address.postalCode'] = this.postalCode.text != null ? this.postalCode.text : "";
		req['address.addressOwnerName1'] = this.ownername1.text != null ? this.ownername1.text : "";
		req['address.addressOwnerName2'] = this.ownername2.text != null ? this.ownername2.text : "";
		req['address.addressOwnerName3'] = this.ownername3.text != null ? this.ownername3.text : "";
		req['address.addressOwnerName4'] = this.ownername4.text != null ? this.ownername4.text : "";
		
		changeReportNameService.request = req;
		changeReportNameService.send();
	}
	
	public function ReportNameResult(event:ResultEvent):void {
		market.itemCombo.selectedIndex=0;
	}