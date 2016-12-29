

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
[Bindable]private var delivEAddressIdList:ArrayCollection;
[Bindable]private var addressTypeList:ArrayCollection;
[Bindable]private var tradeTypeList:ArrayCollection;
[Bindable]private var autoManualFlagList:ArrayCollection;
[Bindable]private var addressIdList:ArrayCollection;
[Bindable]private var urlModeBind:String="Entry";

[Bindable]private var deliveryEAddressRuleSummaryResult:ArrayCollection=new ArrayCollection();
[Bindable]public var eAddressSummaryResult:ArrayCollection=new ArrayCollection();


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
	for each(xmlObj in xmlResponse.dropDownListValues.eaddressReportIdList.item){
		reportNameList.addItem(xmlObj);
	}
	
	groupReportNameList = new ArrayCollection();
	groupReportNameList.addItem(" ");
	for each(xmlObj in xmlResponse.dropDownListValues.eaddressReportGroupIdList.eaddressReportGroupId){
		groupReportNameList.addItem(xmlObj);
	}
	
	delivEAddressIdList = new ArrayCollection();
	delivEAddressIdList.addItem(" ");
	for each(xmlObj in xmlResponse.dropDownListValues.delivRuleEaddressIdList.delivRuleEaddressId){
		delivEAddressIdList.addItem(xmlObj);
	}
	
	addressTypeList = new ArrayCollection();
	addressTypeList.addItem({label: " " , value : " "});
	for each(xmlObj in xmlResponse.dropDownListValues.addressTypeList.item){
		addressTypeList.addItem(xmlObj);
	}
	
	tradeTypeList = new ArrayCollection();
	tradeTypeList.addItem(" ");
	for each(xmlObj in xmlResponse.dropDownListValues.tradeTypeList.tradeType){
		tradeTypeList.addItem(xmlObj);
	}
	
	autoManualFlagList = new ArrayCollection();
	autoManualFlagList.addItem({label: " " , value : " "});
	for each(xmlObj in xmlResponse.dropDownListValues.autoManualFlagList.item){
		autoManualFlagList.addItem(xmlObj);
	}
	//for second grid
	addressIdList = new ArrayCollection();
	addressIdList.addItem({label: " " , value : " "});
	for each(xmlObj in xmlResponse.dropDownListValues.addressIdList.item){
		addressIdList.addItem(xmlObj);
	}

	setEditDeliveryEAddressRuleResult(xmlResponse);
	setEAdressResult(xmlResponse);
	
	//for reset
	resetDelivEAddressRule();
	resetElectronicAddress();

	//Account no
	accountNo.text = xmlResponse.accountNoExp;
	
	//Instrument Code type 
	accountName.text = xmlResponse.shortNameExp;

	//have to populate from Form
	for each ( var rec:XML in xmlResponse.otherAttributes.eaddressRuleDispDynaBeansWrapper.item) {
		rec.isVisible = true;
   		deliveryEAddressRuleSummaryResult.addItem(rec);
 	}
	for each ( var rec:XML in xmlResponse.otherAttributes.eaddressDispDynaBeansWrapper.item) {
		rec.isVisible = true;
		eAddressSummaryResult.addItem(rec);
	}
		
}
     
     private function setEditDeliveryEAddressRuleResult(rs:XML):void{
     	reportName.selectedIndex = getIndexOfLabelValueBean(reportNameList,rs.delivEaddressRule.reportId);
		groupReportName.selectedIndex = getIndex(groupReportNameList,rs.delivEaddressRule.reportGroupId);
		market.itemCombo.text = rs.delivEaddressRule.marketCode.toString();;
		instrumentType.itemCombo.text = rs.delivEaddressRule.instrumentType.toString();
		addressRuleId.selectedIndex = getIndex(delivEAddressIdList,rs.delivEaddressRule.addressId);
		addressType.selectedIndex = getIndexOfLabelValueBean(addressTypeList,rs.delivEaddressRule.addressType);
		tradeType.selectedIndex = getIndex(tradeTypeList,rs.delivEaddressRule.tradeTypePk);
		autoManualFlag.selectedIndex = getIndexOfLabelValueBean(autoManualFlagList, rs.delivEaddressRule.autoManualFeedFlag);
     }
	
	private function setEAdressResult(rs:XML):void{
		addressId.selectedIndex = getIndexOfLabelValueBean(addressIdList,rs.electronicAddress.addressId);
		phone.text = rs.electronicAddress.phone.toString();
		mobile.text = rs.electronicAddress.mobile.toString();
		fax.text = rs.electronicAddress.fax.toString();
		email.text = rs.electronicAddress.email.toString();
		swiftCode.text = rs.electronicAddress.swiftCode.toString();
		telexCountryCode.text = rs.electronicAddress.telexCountryCode.toString();
		telexDialNo.text = rs.electronicAddress.telexDialNo.toString();
		telexAnswerBack.text = rs.electronicAddress.telexAnswerBack.toString();
		recipientName.text = rs.electronicAddress.recipientName.toString();
		oasisCode.text = rs.electronicAddress.oasisCode.toString();
		dtcIdNumber.text = rs.electronicAddress.dtcIdNumber.toString();
		attention.text = rs.electronicAddress.attention.toString();
		dtcIdInterestParty1.text = rs.electronicAddress.dtcIdInterestParty1.toString();
		dtcIdInterestParty2.text = rs.electronicAddress.dtcIdInterestParty2.toString();
		internalAccountNumber1.text = rs.electronicAddress.internalAccountNumber1.toString();
		internalAccountNumber2.text = rs.electronicAddress.internalAccountNumber2.toString();
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
	private function resetDelivEAddressRule():void{
		reportName.selectedIndex=0;
		groupReportName.selectedIndex=0;
		market.itemCombo.selectedIndex=0;
		instrumentType.itemCombo.selectedIndex=0;
		addressRuleId.selectedIndex=0;
		addressType.selectedIndex=0;
		tradeType.selectedIndex=0;
		autoManualFlag.selectedIndex = 0;
		deliveryEAddressRuleSummaryResult.removeAll();
	}

	/**
	 * To add Delivery Address Rule Information
	 */
	public function addDeliveryEAddressRule():void{
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
		}else if(XenosStringUtils.isBlank(autoManualFlag.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.automanflag'));
			return;
		}
		var reqObj : Object = new Object();
		reqObj.method="addEaddressRuleDetail";
		reqObj.srcTabNo = 5;
		actDeliveryEAddressRule.request = populateEDeliveryAddressRule(reqObj);
		actDeliveryEAddressRule.send();
	}
	
	public function editDeliveryEAddressRule(data:Object):void{
		
		addEAddressRuleBtn.includeInLayout=false;
		saveEAddressRuleBtn.includeInLayout=true;
		cancelEAddressRuleBtn.includeInLayout=true;
		
		var reqObj : Object = new Object();
		reqObj.method="editEaddressRuleDetail";
		reqObj.srcTabNo = 5;
		reqObj.editIndexEaddressRule = deliveryEAddressRuleSummaryResult.getItemIndex(data);
		deliveryEAddressRuleSummaryResult.refresh();
		actDeliveryEAddressRule.request = reqObj;
		actDeliveryEAddressRule.send();
	}
	
	public function deleteDeliveryEAddressRule(data:Object):void{
		var reqObj : Object = new Object();
		reqObj.method="deleteEaddressRuleDetail";
		reqObj.srcTabNo = 5;
		reqObj.editIndexEaddressRule = deliveryEAddressRuleSummaryResult.getItemIndex(data);
		actDeliveryEAddressRule.request = reqObj;
		actDeliveryEAddressRule.send();
	}
	
	public function saveDeliveryEAddressRule():void{
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
		}else if(XenosStringUtils.isBlank(autoManualFlag.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.automanflag'));
			return;
		}
		addEAddressRuleBtn.includeInLayout=true;
		saveEAddressRuleBtn.includeInLayout=false;
		cancelEAddressRuleBtn.includeInLayout=false;
		
		var reqObj : Object = new Object();
		reqObj.method="updateEaddressRuleDetail";
		reqObj.srcTabNo = 5;
		actDeliveryEAddressRule.request = populateEDeliveryAddressRule(reqObj);
		actDeliveryEAddressRule.send();
	}
	
	public function cancelDeliveryEAddressRule():void{
		addEAddressRuleBtn.includeInLayout=true;
		saveEAddressRuleBtn.includeInLayout=false;
		cancelEAddressRuleBtn.includeInLayout=false;
		
		var reqObj : Object = new Object();
		reqObj.method="cancelEaddressRuleDetail";
		reqObj.srcTabNo = 5;
		actDeliveryEAddressRule.request = populateEDeliveryAddressRule(reqObj);
		actDeliveryEAddressRule.send();
	}
	
	// Called Result Handler for Add/Delete/Save/Cancel
	private function handleDeliveryEAddressRuleEvent(event:ResultEvent):void{
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
			populateDeliveryEAddressRuleResultTable(xmlResponse);
			setEditDeliveryEAddressRuleResult(xmlResponse);
//			resetDelivEAddressRule();
			errPage.clearError(event);
			}
      	}
	}

	private function populateDeliveryEAddressRuleResultTable(xmlObj:XML):void{
		deliveryEAddressRuleSummaryResult = new ArrayCollection();
		var indx1:int = 0; 
		 for each ( var rec:XML in xmlObj.otherAttributes.eaddressRuleDispDynaBeansWrapper.item) {
	    	 if(xmlObj.editIndexEaddressRule == indx1){
			  	 	rec.isVisible=false;
			   }else{
			   		rec.isVisible=true;
			   }
 			    deliveryEAddressRuleSummaryResult.addItem(rec);
 			    indx1++; 
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

	private function populateEDeliveryAddressRule(reqObj:Object):Object{
		
		reqObj['delivEaddressRule.reportId'] = this.reportName.selectedItem != null ? this.reportName.selectedItem.value : "";
		reqObj['delivEaddressRule.reportGroupId'] = this.groupReportName.selectedItem != null ? this.groupReportName.selectedItem.toString() : "";
		reqObj['delivEaddressRule.marketCode'] = this.market.itemCombo != null ? this.market.itemCombo.text : "";
		reqObj['delivEaddressRule.instrumentType'] = this.instrumentType.itemCombo != null ? this.instrumentType.itemCombo.text : "";
		reqObj['delivEaddressRule.addressId'] = this.addressRuleId.selectedItem != null ? this.addressRuleId.selectedItem.toString() : "";
		reqObj['delivEaddressRule.addressType'] = this.addressType.selectedItem != null ? this.addressType.selectedItem.value : "";
		reqObj['delivEaddressRule.tradeTypePk'] = this.tradeType.selectedItem != null ? this.tradeType.selectedItem.toString() : "";
		reqObj['delivEaddressRule.autoManualFeedFlag'] = this.autoManualFlag.selectedItem != null ? this.autoManualFlag.selectedItem.value : "";
		
		return reqObj;
	}
	
	//for second grid
	private function resetElectronicAddress():void{
		
		addressId.selectedIndex=0;
		phone.text = XenosStringUtils.EMPTY_STR;
		mobile.text = XenosStringUtils.EMPTY_STR;
		fax.text = XenosStringUtils.EMPTY_STR;
		email.text = XenosStringUtils.EMPTY_STR;
		swiftCode.text = XenosStringUtils.EMPTY_STR; 
		telexCountryCode.text = XenosStringUtils.EMPTY_STR;
		telexDialNo.text = XenosStringUtils.EMPTY_STR; 
		telexAnswerBack.text = XenosStringUtils.EMPTY_STR;
		recipientName.text = XenosStringUtils.EMPTY_STR; 
		oasisCode.text = XenosStringUtils.EMPTY_STR;  
		dtcIdNumber.text = XenosStringUtils.EMPTY_STR;
		dtcIdInterestParty1.text = XenosStringUtils.EMPTY_STR; 
		dtcIdInterestParty2.text = XenosStringUtils.EMPTY_STR;
		internalAccountNumber1.text = XenosStringUtils.EMPTY_STR; 
		internalAccountNumber2.text = XenosStringUtils.EMPTY_STR; 
		eAddressSummaryResult.removeAll();
	}


	/**
	 * To add E-Address Information
	 */
	public function addElectronicAddress():void{
		if(XenosStringUtils.isBlank(addressId.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.addressid'));
			return;
		}else if(XenosStringUtils.isBlank(phone.text) && XenosStringUtils.isBlank(mobile.text) 
					&& XenosStringUtils.isBlank(fax.text) && XenosStringUtils.isBlank(email.text) 
					&& XenosStringUtils.isBlank(swiftCode.text) && XenosStringUtils.isBlank(telexCountryCode.text) 
					&& XenosStringUtils.isBlank(telexDialNo.text) && XenosStringUtils.isBlank(telexAnswerBack.text) 
					&& XenosStringUtils.isBlank(recipientName.text) && XenosStringUtils.isBlank(oasisCode.text) 
					&& XenosStringUtils.isBlank(dtcIdNumber.text) && XenosStringUtils.isBlank(attention.text) 
					&& XenosStringUtils.isBlank(dtcIdInterestParty1.text) && XenosStringUtils.isBlank(dtcIdInterestParty2.text) 
					&& XenosStringUtils.isBlank(internalAccountNumber1.text) && XenosStringUtils.isBlank(internalAccountNumber2.text)){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.oneeaddr'));
			return;
		}
		var reqObj : Object = new Object();
		reqObj.method="addEaddressDetail";
		reqObj.srcTabNo = 5;
		actElectronicAddressService.request = populateEAddress(reqObj);
		actElectronicAddressService.send();
	}
	
	public function editElectronicAddress(data:Object):void{
		
		addEAddressBtn.visible=false;
		saveEAddressBtn.visible=true;
		cancelEAddressBtn.visible=true;
		
		var reqObj : Object = new Object();
		reqObj.method="editEaddressDetail";
		reqObj.srcTabNo = 5;
		reqObj.editIndexEaddress = eAddressSummaryResult.getItemIndex(data);
		eAddressSummaryResult.refresh();
		actElectronicAddressService.request = reqObj;
		actElectronicAddressService.send();
	}
	
	public function deleteElectronicAddress(data:Object):void{
		var reqObj : Object = new Object();
		reqObj.method="deleteEaddressDetail";
		reqObj.srcTabNo = 5;
		reqObj.editIndexEaddress = eAddressSummaryResult.getItemIndex(data);
		actElectronicAddressService.request = reqObj;
		actElectronicAddressService.send();
	}
	public function saveElectronicAddress():void{
		addEAddressBtn.visible=true;
		saveEAddressBtn.visible=false;
		cancelEAddressBtn.visible=false;
		
		var reqObj : Object = new Object();
		reqObj.method="updateEaddressDetail";
		reqObj.srcTabNo = 5;
		actElectronicAddressService.request = populateEAddress(reqObj);
		actElectronicAddressService.send();
	}
	public function cancelElectronicAddress():void{
		addEAddressBtn.visible=true;
		saveEAddressBtn.visible=false;
		cancelEAddressBtn.visible=false;
		
		var reqObj : Object = new Object();
		reqObj.method="cancelEaddressDetail";
		reqObj.srcTabNo = 5;
		actElectronicAddressService.request = populateEAddress(reqObj);
		actElectronicAddressService.send();
	}

	// Called Result Handler for Add/Delete/Save/Cancel
	private function handleEAddressEvent(event:ResultEvent):void{
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
			populateEAddressResultTable(xmlResponse);
			setEAdressResult(xmlResponse);
			//for populate address id of first grid
			delivEAddressIdList = new ArrayCollection();
			delivEAddressIdList.addItem(" ");
			for each(xmlObj in xmlResponse.dropDownListValues.delivRuleEaddressIdList.delivRuleEaddressId){
				delivEAddressIdList.addItem(xmlObj);
			}
//			resetElectronicAddress();
			errPage.clearError(event);
			}
      	}
	}

	private function populateEAddressResultTable(xmlObj:XML):void{
		eAddressSummaryResult = new ArrayCollection();
		var indx1:int = 0; 
		 for each ( var rec:XML in xmlObj.otherAttributes.eaddressDispDynaBeansWrapper.item) {
	    	 if(xmlObj.editIndexEaddress == indx1){
			  	 	rec.isVisible=false;
			   }else{
			   		rec.isVisible=true;
			   }
 			    eAddressSummaryResult.addItem(rec);
 			    indx1++; 
		 }
	}

	private function populateEAddress(reqObj:Object):Object{
		
		reqObj['electronicAddress.addressId'] = this.addressId.selectedItem != null ? this.addressId.selectedItem.value : "";
		reqObj['electronicAddress.phone'] = this.phone.text != null ? this.phone.text : "";
		reqObj['electronicAddress.mobile'] = this.mobile.text != null ? this.mobile.text : "";
		reqObj['electronicAddress.fax'] = this.fax.text != null ? this.fax.text : "";
		reqObj['electronicAddress.email'] = this.email.text != null ? this.email.text : "";
		reqObj['electronicAddress.swiftCode'] = this.swiftCode.text != null ? this.swiftCode.text : "";
		reqObj['electronicAddress.tlxCountryCode'] = this.telexCountryCode.text != null ? this.telexCountryCode.text : "";
		reqObj['electronicAddress.tlxDial'] = this.telexDialNo.text != null ? this.telexDialNo.text : "";
		reqObj['electronicAddress.answerBack'] = this.telexAnswerBack.text != null ? this.telexAnswerBack.text : "";
		reqObj['electronicAddress.recipientName'] = this.recipientName.text != null ? this.recipientName.text : "";
		reqObj['electronicAddress.oasysCode'] = this.oasisCode.text != null ? this.oasisCode.text : "";
		reqObj['electronicAddress.dtcIdNumber'] = this.dtcIdNumber.text != null ? this.dtcIdNumber.text : "";
		reqObj['electronicAddress.attention'] = this.attention.text != null ? this.attention.text : "";
		reqObj['electronicAddress.dtcIdInterestParty1'] = this.dtcIdInterestParty1.text != null ? this.dtcIdInterestParty1.text : "";
		reqObj['electronicAddress.dtcIdInterestParty2'] = this.dtcIdInterestParty2.text != null ? this.dtcIdInterestParty2.text : "";
		reqObj['electronicAddress.internalAccountNumber1'] = this.internalAccountNumber1.text != null ? this.internalAccountNumber1.text : "";
		reqObj['electronicAddress.internalAccountNumber2'] = this.internalAccountNumber2.text != null ? this.internalAccountNumber2.text : "";
	
		return reqObj;
	}
	
	public function loadMarket():void{
		var req:Object = new Object();
		
	//	req.method="loadDefaultMarket";
		req.parameter="EADDRESS";
		req['srcTabNo'] = '5';
		req['delivEaddressRule.reportId'] = this.reportName.selectedItem != null ? this.reportName.selectedItem.value : "";
		req['delivEaddressRule.reportGroupId'] = this.groupReportName.selectedItem != null ? this.groupReportName.selectedItem.toString() : "";
		req['delivEaddressRule.marketCode'] = this.market.itemCombo != null ? this.market.itemCombo.text : "";
		req['delivEaddressRule.instrumentType'] = this.instrumentType.itemCombo != null ? this.instrumentType.itemCombo.text : "";
		req['delivEaddressRule.addressId'] = this.addressRuleId.selectedItem != null ? this.addressRuleId.selectedItem.toString() : "";
		req['delivEaddressRule.addressType'] = this.addressType.selectedItem != null ? this.addressType.selectedItem.value : "";
		req['delivEaddressRule.tradeTypePk'] = this.tradeType.selectedItem != null ? this.tradeType.selectedItem.toString() : "";
		req['delivEaddressRule.autoManualFeedFlag'] = this.autoManualFlag.selectedItem != null ? this.autoManualFlag.selectedItem.value : "";
		
		req['electronicAddress.addressId'] = this.addressId.selectedItem != null ? this.addressId.selectedItem.value : "";
		req['electronicAddress.phone'] = this.phone.text != null ? this.phone.text : "";
		req['electronicAddress.mobile'] = this.mobile.text != null ? this.mobile.text : "";
		req['electronicAddress.fax'] = this.fax.text != null ? this.fax.text : "";
		req['electronicAddress.email'] = this.email.text != null ? this.email.text : "";
		req['electronicAddress.swiftCode'] = this.swiftCode.text != null ? this.swiftCode.text : "";
		req['electronicAddress.tlxCountryCode'] = this.telexCountryCode.text != null ? this.telexCountryCode.text : "";
		req['electronicAddress.tlxDial'] = this.telexDialNo.text != null ? this.telexDialNo.text : "";
		req['electronicAddress.answerBack'] = this.telexAnswerBack.text != null ? this.telexAnswerBack.text : "";
		req['electronicAddress.recipientName'] = this.recipientName.text != null ? this.recipientName.text : "";
		req['electronicAddress.oasysCode'] = this.oasisCode.text != null ? this.oasisCode.text : "";
		req['electronicAddress.dtcIdNumber'] = this.dtcIdNumber.text != null ? this.dtcIdNumber.text : "";
		req['electronicAddress.attention'] = this.attention.text != null ? this.attention.text : "";
		req['electronicAddress.dtcIdInterestParty1'] = this.dtcIdInterestParty1.text != null ? this.dtcIdInterestParty1.text : "";
		req['electronicAddress.dtcIdInterestParty2'] = this.dtcIdInterestParty2.text != null ? this.dtcIdInterestParty2.text : "";
		req['electronicAddress.internalAccountNumber1'] = this.internalAccountNumber1.text != null ? this.internalAccountNumber1.text : "";
		req['electronicAddress.internalAccountNumber2'] = this.internalAccountNumber2.text != null ? this.internalAccountNumber2.text : "";
		
		changeReportNameService.request = req;
		changeReportNameService.send();
	}
	
	public function ReportNameResult(event:ResultEvent):void {
		market.itemCombo.selectedIndex=0;
	}