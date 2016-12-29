
 
 	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.utils.XenosStringUtils;
 	
 	import flash.events.Event;
 	import flash.events.MouseEvent;
 	
 	import mx.collections.ArrayCollection;
 	import mx.events.CloseEvent;
 	import mx.managers.PopUpManager;
 	import mx.rpc.events.ResultEvent;
 	import mx.utils.StringUtil;
 	
 	
	[Bindable]
    public var addressIds:ArrayCollection;
    [Bindable]
    public var reportNames:ArrayCollection;
    [Bindable]
    public var grpRptNames:ArrayCollection;
    [Bindable]
    public var addressTypes:ArrayCollection;
    [Bindable]
    public var autoManualFlags:ArrayCollection;
    [Bindable]
    public var tmpAddressIds:ArrayCollection ;
    
    [Bindable]
    public var dpDeliveryEaddressList:ArrayCollection ;
    [Bindable]
    public var dpDeliveryEAddressRules:ArrayCollection;

    [Bindable]
    public var editIndex:int;
    
    [Bindable]
    public var editEaddressIndex:int;
    
    public var isForEdit:Boolean = false;
    
    public var isForDelete:Boolean = false;
    
    public var isForEaddressEdit:Boolean = false;
    
    public var isForEaddressDelete:Boolean = false;
    [Bindable]
    public var mode:String = "";
    
    [Bindable]
    public var confirm:Boolean = false;
    private function okHandler(e:Event):void{
    	if(this.mode == "close" || confirm){
    		FinInstEntry(this.owner).app.submitButtonInstance = FinInstEntry(this.owner).defaultBtn;
    		PopUpManager.removePopUp(this);
    	}else {
    		eAddressSubmit.send();
    	}
    }
    
    private function addEAddressRsltHandler(event:ResultEvent):void{
    	var rs : XML = XML(event.result);
    	if (null != event) {
    		errPage.clearError(event);
    		if(rs.child("electronicAddresses").length() > 0){
    			var eaddresses:XML = XML(rs.electronicAddresses);
    			dpDeliveryEaddressList.removeAll();
    			
        		if(eaddresses.child("electronicAddress").length()>0) {
        			//errPage.clearError(event);
        			//dpDeliveryEaddressList.removeAll();
        			try {
            			for each ( var rec:XML in eaddresses.electronicAddress ) {
	 				    	//trace("xml str.."+rec.toXmlString());
	 				    	dpDeliveryEaddressList.addItem(rec);
				    	}
				    	modifyEAddressResult();
				    }catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    	}
        		}
        		
        		//Populate the addressIdList to populate in the Delivery Rule Entry
        		tmpAddressIds.removeAll();
        		if(rs.child("addressIdList").length() > 0){
        			var addrId:XML = XML(rs.addressIdList);
        			tmpAddressIds.addItem(" ");
        			for each( var item:XML in addrId.addressId){
        				tmpAddressIds.addItem(item);
        			}
        		}
        		showHideEaddressAddBtn(isForEaddressEdit);
        		if(!isForEaddressDelete){
		     		resetEAddressFields();
		     	}
        		
    		}else if(rs.child("Errors").length()>0) {
    			//some error found
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
    		}else {
    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	dpDeliveryEaddressList.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
    	}
    	if(isForEaddressEdit){
     		electronicAddressEntry.removeEventListener(ResultEvent.RESULT,updateEAddressRsltHandler);
     	}else{
     		electronicAddressEntry.removeEventListener(ResultEvent.RESULT,addEAddressRsltHandler);
     	}
     	
    }
    
    private function modifyEAddressResult():void{
     	var i :int = 0;
     	for(;i<dpDeliveryEaddressList.length;i++){
     		if(this.mode == "close" || confirm){
     			dpDeliveryEaddressList[i].selected = false;
     		}else{
	     		dpDeliveryEaddressList[i].selected = true;
	     	}
	     	dpDeliveryEaddressList[i].index = i;
	     }
	     (addEAddr.dataProvider as ArrayCollection).refresh();
     }
     
    private function addElectronicAddress(e:Event):void{
    	isForEaddressEdit = false;
    	var validate:Boolean = false;
    	validate = onValidateEaddressMore();
    	if(validate){
	    	var requestObj :Object = populateEAddressRequestParams(!isForEaddressEdit);
	    	if(this.mode == "entry"){
    			electronicAddressEntry.url="ref/finInstEntryDispatch.action?"
    	    }else if(this.mode == "amendment"){
    			electronicAddressEntry.url="ref/finInstAmendDispatch.action?"
    		}
	    	
	    	electronicAddressEntry.request = requestObj;
	    	electronicAddressEntry.addEventListener(ResultEvent.RESULT,addEAddressRsltHandler);
	    	
	    	electronicAddressEntry.send();
    	}
    }
    
    private function populateEAddressRequestParams(flagForEntry:Boolean):Object{
    	
    	var reqObj : Object = new Object();
    	
    	if (flagForEntry == true)
     		reqObj.method = "addElectronicAddress";
     	
     	else{
     		reqObj.method = "updateElectronicAddress";
     		reqObj['editIndexEaddress'] = editEaddressIndex;
     	}
    	//reqObj.method = "addElectronicAddress";
    	reqObj['elctronicAddress.addressId'] = (this.addrIds.selectedItem != null ? this.addrIds.selectedItem.value : "");
    	reqObj['elctronicAddress.phone'] = phone.text;
    	reqObj['elctronicAddress.mobile'] = mobile.text;
    	reqObj['elctronicAddress.fax'] = fax.text;
    	reqObj['elctronicAddress.email'] = email.text;
    	reqObj['elctronicAddress.swiftCode'] = swiftcode.text;
    	reqObj['elctronicAddress.tlxCountryCode'] = telexcountrycode.text;
    	reqObj['elctronicAddress.tlxDial'] = telexdialno.text;
    	reqObj['elctronicAddress.answerBack'] = telexanswerback.text;
    	reqObj['elctronicAddress.recipientName'] = recipientname.text;
    	reqObj['elctronicAddress.oasysCode'] = oasiscode.text;
    	reqObj['elctronicAddress.attention'] = attention.text;
    	
    	return reqObj;
    }
    
    private function addEaddressRule(e:Event):void{
    	isForEdit = false;
    	var validate:Boolean = false;
    	validate = onValidateEaddressRuleMore();
    	if(validate){
	    	var requestObj :Object = populateEAddressRuleParams(!isForEdit);
	    	if(this.mode == "entry"){
    			eAddressRuleEntry.url="ref/finInstEntryDispatch.action?"
    	    }else if(this.mode == "amendment"){
    			eAddressRuleEntry.url="ref/finInstAmendDispatch.action?"
    		}
	    	eAddressRuleEntry.request = requestObj;
	    	eAddressRuleEntry.addEventListener(ResultEvent.RESULT,addEAddressRuleRsltHandler);
	    	
	    	eAddressRuleEntry.send();
    	}
    }
    
     private function onValidateEaddressRuleMore():Boolean{
     	var alertStr:String = XenosStringUtils.EMPTY_STR;
     	var reportId:String = (this.report.selectedItem != null ? this.report.selectedItem.value : "");
     	var grpRpt:String = (this.grpNames.selectedItem != null ? this.grpNames.selectedItem.toString() : "");
     	var addrId:String = (this.taddrIds.selectedItem != null ? this.taddrIds.selectedItem.toString() : ""); 
     	var amFlag :String = (this.amflag.selectedItem != null ? this.amflag.selectedItem.value : "");
     	var addrType:String = (this.addrtype.selectedItem != null ? this.addrtype.selectedItem.value : "");
     	
     	if(XenosStringUtils.isBlank(reportId) && XenosStringUtils.isBlank(grpRpt)) 
	    {
	         alertStr += this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.reportid') + "\n";
	    }
	    if(XenosStringUtils.isBlank(addrId)){
	    	alertStr += this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.addressid') + "\n";
	    }
	    if(XenosStringUtils.isBlank(amFlag)){
	    	alertStr += this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.automanflag') + "\n";
	    }
	    if(XenosStringUtils.isBlank(addrType)){
	    	alertStr += this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.addresstype') + "\n";
	    }
	    if(!XenosStringUtils.equals(alertStr,XenosStringUtils.EMPTY_STR)){
    		XenosAlert.error(alertStr);
    		return false;
    	}
    	return true;
     	
     }
    private function onValidateEaddressMore():Boolean{
    	var addressId:String = (this.addrIds.selectedItem != null ? this.addrIds.selectedItem.value : "");
    	var alertStr:String = XenosStringUtils.EMPTY_STR;
    	if(XenosStringUtils.isBlank(addressId)) 
	    {
	         alertStr += this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.addressid') + "\n";
	    }
	    if(XenosStringUtils.isBlank(this.phone.text) && XenosStringUtils.isBlank(this.fax.text)
	    && XenosStringUtils.isBlank(this.mobile.text) && XenosStringUtils.isBlank(this.email.text)
	    && XenosStringUtils.isBlank(this.swiftcode.text) && XenosStringUtils.isBlank(this.telexcountrycode.text)
	    && XenosStringUtils.isBlank(this.telexdialno.text) && XenosStringUtils.isBlank(this.telexanswerback.text)
	    && XenosStringUtils.isBlank(this.recipientname.text) && XenosStringUtils.isBlank(this.oasiscode.text)
	    && XenosStringUtils.isBlank(this.attention.text)){
	    	alertStr += this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.oneeaddr') + "\n";
	    }
	    if(!XenosStringUtils.equals(alertStr,XenosStringUtils.EMPTY_STR)){
    		XenosAlert.error(alertStr);
    		return false;
    	}
    	if(!XenosStringUtils.isBlank(this.swiftcode.text)){
    		var swiftTxt : String = this.swiftcode.text;
    		if(StringUtil.trim(swiftTxt).length != 11){
    			alertStr += this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.swiftcode.length') + "\n";
    		}
    		if(!XenosStringUtils.isAlphaNumeric(swiftTxt)){
    			alertStr += this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.swiftcode.format') + "\n";
    		}
    		if(!XenosStringUtils.equals(alertStr,XenosStringUtils.EMPTY_STR)){
	    		XenosAlert.error(alertStr);
	    		return false;
    		}
    	}
    	return true;
    }
    /**
    * Populate the request parameters for adding/updating a row for
    * Delivery E-Address Rule Info.
    */
     private function populateEAddressRuleParams(flagForEntry:Boolean):Object{
     	
     	var reqObj : Object = new Object();
     	if (flagForEntry == true)
     		reqObj.method = "addEaddressRuleDetail";
     	
     	else{
     		reqObj.method = "updateEaddressRuleDetail";
     		reqObj['editIndexEaddressRule'] = editIndex;
     	}	
     	
     	reqObj['deliveryEAddressRulePage.reportId'] = (this.report.selectedItem != null ? this.report.selectedItem.value : "");
     	reqObj['deliveryEAddressRulePage.reportGroupId'] = (this.grpNames.selectedItem != null ? this.grpNames.selectedItem : "");
     	reqObj['deliveryEAddressRulePage.addressId'] = (this.taddrIds.selectedItem != null ? this.taddrIds.selectedItem : "");
     	reqObj['deliveryEAddressRulePage.addressType'] = (this.addrtype.selectedItem != null ? this.addrtype.selectedItem.value : "");
     	reqObj['deliveryEAddressRulePage.autoManualFeedFlag'] = (this.amflag.selectedItem != null ? this.amflag.selectedItem.value : "");
     	
     	return reqObj;
     	
     }
     /**
     * Result Handler for entering the Delivery E-Address Rule Info.
     * This is also used as Result handler for updating a particular row
     * (ie. When Edit button is clicked and then Save is being done on the 
     * particular record) or while deleting a row (Delete button
     * is clicked.
     */
     private function addEAddressRuleRsltHandler(event:ResultEvent):void{
     	
     	var rs : XML = XML(event.result);
     	if (null != event) {
     		if(rs.child("deliveryEAddressRules").length() > 0){
     			var eaddresses:XML = XML(rs.deliveryEAddressRules);
    			dpDeliveryEAddressRules.removeAll();
        		if(eaddresses.child("deliveryEAddressRule").length()>0) {
        			errPage.clearError(event);
        			//dpDeliveryEAddressRules.removeAll();
        			try {
        				//var indx:int =0;
            			for each ( var rec:XML in eaddresses.deliveryEAddressRule ) {
            				dpDeliveryEAddressRules.addItem(rec);
	 				    }
				    	modifySummaryResult();
				    }catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    	}
        		}
        		
        		showHideAddBtn(isForEdit);
        		if(!isForDelete){
		     		resetEAddressRuleFields();
		     	}
     		}else if(rs.child("Errors").length()>0) {
     			//some error found
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
    		}else {
    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	dpDeliveryEAddressRules.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
     	}
     	if(isForEdit){
     		eAddressRuleEntry.removeEventListener(ResultEvent.RESULT,updateEAddressRuleRsltHandler);
     	}else{
     		eAddressRuleEntry.removeEventListener(ResultEvent.RESULT,addEAddressRuleRsltHandler);
     	}
     	
     }
     
     private function modifySummaryResult():void{
     	var i :int = 0;
     	for(;i<dpDeliveryEAddressRules.length;i++){
     		if(this.mode == "close" || confirm){
     			dpDeliveryEAddressRules[i].selected = false;
     		}else{
	     		dpDeliveryEAddressRules[i].selected = true;
	     	}
	     	dpDeliveryEAddressRules[i].index = i;
	     }
	     (addEAddrRule.dataProvider as ArrayCollection).refresh();
     }
     
     public function eAddrRuleEditHandler(e:Event,indx:int):void{
     	editIndex = indx;
     	var editableObj : XML = dpDeliveryEAddressRules[indx];
     	// Done to reset if any other data has been clicked for modification.
     	// and without saving another record has been clicked
     	// for modification.
     	modifySummaryResult();
     	
     	editableObj.selected=false;
     	//Set the report Id
     	var selIndx:int=0;
     	for each(var item1:Object in reportNames as ArrayCollection){
     		if(XenosStringUtils.equals(item1.value,editableObj.reportId)){
     			
     			selIndx= reportNames.getItemIndex(item1);
     			this.report.selectedItem = item1;
     			break;
     		}
     	}
     	
     	selIndx = 0;
     	for each(var item:String in tmpAddressIds){
     		if(item == editableObj.addressId){
     			this.taddrIds.selectedItem = item;
     			break;
     		}
     		
     	}
     	
     	selIndx = 0;
     	for each(var item1:Object in addressTypes){
     		if(XenosStringUtils.equals(item1.value,editableObj.addressType)){	
     			this.addrtype.selectedItem = item1;
     			break;
     		}
     	}
     	
     	selIndx = 0;
     	for each(var item1:Object in autoManualFlags){
     		if(XenosStringUtils.equals(item1.label,editableObj.autoManualFeedFlagExp)){	
     				this.amflag.selectedItem = item1;
     				break;
     		}
     	}
     
     	var dp : ArrayCollection = addEAddrRule.dataProvider as ArrayCollection;
     	dp.setItemAt(editableObj,indx);
     	dp.refresh();
     	
     	isForEdit = true;
     	showHideAddBtn(isForEdit);
     	
     }
     
     private function showHideAddBtn(editFlag:Boolean):void{
     	
     	cxldeliveryInfo.includeInLayout = editFlag;
     	cxldeliveryInfo.visible = editFlag;
     	savedeliveryInfo.includeInLayout = editFlag;
     	savedeliveryInfo.visible = editFlag;
     	adddeliveryInfo.includeInLayout = !editFlag;
     	adddeliveryInfo.visible = !editFlag;
     
     }
     
     public function eAddrRuleDeleteHandler(e:Event,delIndex:int):void{
     	isForDelete = true;
     	
     	var requestObj :Object = new Object();
     	requestObj.method="deleteEaddressRuleDetail";
     	requestObj['editIndexEaddressRule'] = delIndex;
     	
     	eAddressRuleEntry.request = requestObj;
     	if(this.mode == "entry"){
			eAddressRuleEntry.url="ref/finInstEntryDispatch.action?"
	    }else if(this.mode == "amendment"){
			eAddressRuleEntry.url="ref/finInstAmendDispatch.action?"
		}
     	eAddressRuleEntry.addEventListener(ResultEvent.RESULT,addEAddressRuleRsltHandler);
     	
     	eAddressRuleEntry.send();
     	
     }

     private function saveEaddressRule(event:Event):void{
     	
     	isForEdit = false;
     	isForDelete = false;
     	var requestObj :Object = populateEAddressRuleParams(isForEdit);
    	eAddressRuleEntry.request = requestObj;
    	if(this.mode == "entry"){
			eAddressRuleEntry.url="ref/finInstEntryDispatch.action?"
	    }else if(this.mode == "amendment"){
			eAddressRuleEntry.url="ref/finInstAmendDispatch.action?"
		}
    	eAddressRuleEntry.addEventListener(ResultEvent.RESULT,updateEAddressRuleRsltHandler);
    	
    	eAddressRuleEntry.send();
     }
     
     private function updateEAddressRuleRsltHandler(e:ResultEvent):void{
     	addEAddressRuleRsltHandler(e);
     	//showHideAddBtn(isForEdit);
     	//resetEAddressRuleFields();
     }
     
     private function cxlEaddressRule(event:Event):void{
     	isForEdit = false;
     	var requestObj :Object = new Object();
     	requestObj.method="cancelEaddressRuleDetail";
     	eAddressRuleEntry.request = requestObj;
     	if(this.mode == "entry"){
			eAddressRuleEntry.url="ref/finInstEntryDispatch.action?"
	    }else if(this.mode == "amendment"){
			eAddressRuleEntry.url="ref/finInstAmendDispatch.action?"
		}
     	// Done to reset if any other data has been clicked for modification.
     	// and without saving another record has been clicked
     	// for modification.
     	modifySummaryResult();
     	showHideAddBtn(isForEdit);
     	resetEAddressRuleFields();
     	
     	var dp : ArrayCollection = addEAddrRule.dataProvider as ArrayCollection;
     	dp.refresh();
     	
     	eAddressRuleEntry.send();
     
     }
     
     private function resetEAddressRuleFields():void{
     	this.report.selectedIndex = 0;
     	this.amflag.selectedIndex = 0;
     	this.addrtype.selectedIndex = 0;
     	this.taddrIds.selectedIndex = 0;
     	this.grpNames.selectedIndex = 0;
     }
     
     public function eAddrEditHandler(e:Event,indx:int):void{
     	//var indx :int = parseInt(str);
     	editEaddressIndex = indx;
     	var editableObj : XML = dpDeliveryEaddressList[indx];
     	// Done to reset if any other data has been clicked for modification.
     	// and without saving another record has been clicked
     	// for modification.
     	modifyEAddressResult();
     	
     	editableObj.selected=false;
     	//Set the report Id
     	var selIndx:int=0;
     	for each(var item:Object in addressIds){
     		if(XenosStringUtils.equals(item.value,editableObj.addressId)){
     		
     			this.addrIds.selectedItem = item;
     			break;
     		}
     		
     	}
     	
     	this.phone.text = editableObj.phone;
     	this.mobile.text = editableObj.mobile;
     	this.fax.text = editableObj.fax;
     	this.email.text = editableObj.email;
     	this.swiftcode.text = editableObj.swiftCode;
     	this.telexcountrycode.text = editableObj.tlxCountryCode;
     	this.telexdialno.text = editableObj.tlxDial;
     	this.telexanswerback.text = editableObj.answerBack;
     	this.recipientname.text = editableObj.recipientName;
     	this.oasiscode.text = editableObj.oasysCode;
     	this.attention.text = editableObj.attention;
     	
     	var dp : ArrayCollection = addEAddr.dataProvider as ArrayCollection;
     	dp.setItemAt(editableObj,indx);
     	dp.refresh();
     	
     	isForEaddressEdit = true;
     	showHideEaddressAddBtn(isForEaddressEdit);
     	
     }
     
     private function resetEAddressFields():void{
     	this.addrIds.selectedIndex =0;
     	this.phone.text = XenosStringUtils.EMPTY_STR;
     	this.mobile.text = XenosStringUtils.EMPTY_STR;
     	this.fax.text = XenosStringUtils.EMPTY_STR;
     	this.email.text = XenosStringUtils.EMPTY_STR;
     	this.swiftcode.text = XenosStringUtils.EMPTY_STR;
     	this.telexcountrycode.text = XenosStringUtils.EMPTY_STR;
     	this.telexdialno.text = XenosStringUtils.EMPTY_STR;
     	this.telexanswerback.text = XenosStringUtils.EMPTY_STR;
     	this.recipientname.text = XenosStringUtils.EMPTY_STR;
     	this.oasiscode.text = XenosStringUtils.EMPTY_STR;
     	this.attention.text = XenosStringUtils.EMPTY_STR;
     }
     
      private function showHideEaddressAddBtn(editFlag:Boolean):void{
     	
     	cxleaddrbtn.includeInLayout = editFlag;
     	cxleaddrbtn.visible = editFlag;
     	saveeaddrbtn.includeInLayout = editFlag;
     	saveeaddrbtn.visible = editFlag;
     	eaddrbtn.includeInLayout = !editFlag;
     	eaddrbtn.visible = !editFlag;
     
     }
     
     private function saveEaddress(event:Event):void{
     	isForEaddressEdit = false;
     	isForEaddressDelete = false;
     	var requestObj :Object = populateEAddressRequestParams(isForEaddressEdit);
    	electronicAddressEntry.request = requestObj;
    	if(this.mode == "entry"){
			electronicAddressEntry.url="ref/finInstEntryDispatch.action?"
	    }else if(this.mode == "amendment"){
			electronicAddressEntry.url="ref/finInstAmendDispatch.action?"
		}
    	electronicAddressEntry.addEventListener(ResultEvent.RESULT,updateEAddressRsltHandler);
    	
    	electronicAddressEntry.send();
    	
     }
     
     private function updateEAddressRsltHandler(e:ResultEvent):void{
     	addEAddressRsltHandler(e);
     	//showHideEaddressAddBtn(isForEaddressEdit);
     }
     
     private function cxlEaddress(event:Event):void{
     	isForEaddressEdit = false;
     	var requestObj :Object = new Object();
     	requestObj.method="cancelElectronicAddress";
     	electronicAddressEntry.request = requestObj;
     	if(this.mode == "entry"){
			electronicAddressEntry.url="ref/finInstEntryDispatch.action?"
	    }else if(this.mode == "amendment"){
			electronicAddressEntry.url="ref/finInstAmendDispatch.action?"
		}
     	// Done to reset if any other data has been clicked for modification.
     	// and without saving another record has been clicked
     	// for modification.
     	modifyEAddressResult();
     	showHideEaddressAddBtn(isForEaddressEdit);
     	resetEAddressFields();
     	
     	var dp : ArrayCollection = addEAddr.dataProvider as ArrayCollection;
     	dp.refresh();
     	
     	electronicAddressEntry.send();
     }
     
     public function eAddrDeleteHandler(event:Event,delIndex:int):void{
     	trace("eAddrDeleteHandler.. with indx .: "+delIndex);
     	isForEaddressDelete = true;
     	
     	var requestObj :Object = new Object();
     	requestObj.method="deleteElectronicAddress";
     	requestObj['editIndexEaddress'] = delIndex;
     	
     	electronicAddressEntry.request = requestObj;
     	if(this.mode == "entry"){
			electronicAddressEntry.url="ref/finInstEntryDispatch.action?"
	    }else if(this.mode == "amendment"){
			electronicAddressEntry.url="ref/finInstAmendDispatch.action?"
		}
     	electronicAddressEntry.addEventListener(ResultEvent.RESULT,addEAddressRsltHandler);
     	
     	electronicAddressEntry.send();
     }
     
     private function commitEAddressRsltHandler(event:ResultEvent):void{
     	var rs : XML = XML(event.result);
     	if(null != event){
	     	if(rs.child("Errors").length()>0) {
	     		//some error found
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
	     	}else {
	     		//No errors found during validation
	     		//Close the pop up
	     		FinInstEntry(this.owner).app.submitButtonInstance = FinInstEntry(this.owner).defaultBtn;
	     		PopUpManager.removePopUp(this);
	     	}
     	}
     	
     }
     
     private function resetHandler(e:Event):void{
     	isForDelete = false;
     	isForEaddressDelete = false;
     	var reqObj :Object = new Object();
     	if(this.mode == "entry"){
			reqObj.method = "resetEAddressDetails";
			eAddressReset.url="ref/finInstEntryDispatch.action?"
		}else if(this.mode == "amendment"){
			reqObj.method = "resetEaddressForAmend";
			eAddressReset.url="ref/finInstAmendDispatch.action?"
		}
		
		eAddressReset.request = reqObj;
     	eAddressReset.send();
     }
     
     private function resetEAddressRsltHandler(e:ResultEvent):void{
     	addEAddressRsltHandler(e);
     	addEAddressRuleRsltHandler(e);
     }
     
     private function eAddressCloseHandler(event:CloseEvent):void{
     	if(!confirm){
     		resetHandler(new Event(MouseEvent.CLICK));
     	}
     	PopUpManager.removePopUp(this);
     }