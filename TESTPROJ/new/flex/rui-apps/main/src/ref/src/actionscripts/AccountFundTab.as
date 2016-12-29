

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
import com.nri.rui.ref.validators.AccountFundTabValidator;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.XenosStringUtils;
[Bindable]public var xml:XML;
[Bindable]private var officeIdList:ArrayCollection;
[Bindable]private var swiftReceiveOfficeIdList:ArrayCollection;
[Bindable]private var copyInstructionTypeList:ArrayCollection;
[Bindable]private var fundCategoryList:ArrayCollection;
[Bindable]private var taxFeeInclusionList:ArrayCollection;
[Bindable]private var iconRequiredList:ArrayCollection;
[Bindable]private var gemsRequiredList:ArrayCollection;
//[Bindable]private var int1RequiredList:ArrayCollection;
[Bindable]private var cashViewerRequiredList:ArrayCollection;
[Bindable]private var fbpifRequiredList:ArrayCollection;
[Bindable]private var lmPositionCustodyList:ArrayCollection;
[Bindable]private var formaRequiredList:ArrayCollection;
[Bindable]private var tfRequiredList:ArrayCollection;
[Bindable]private var cxlForexTagReqdList:ArrayCollection;
[Bindable]private var lmImValidationRequiredList:ArrayCollection;
//[Bindable]private var rtfpRequiredList:ArrayCollection;
[Bindable]private var shortSellFlagList:ArrayCollection;
[Bindable]private var fundCodeTypeList:ArrayCollection;
[Bindable]private var fundCodeSummaryResult:ArrayCollection = new ArrayCollection();
[Bindable]private var urlModeBind:String="Entry";
[Bindable]private var editMode:Boolean = false;

private static var CP_INTERNAL:String="INTERNAL";
private static var CP_BANKCUST:String="BANK/CUSTODIAN";
private static var CP_BROKER:String="BROKER";


override public function populateRequest():Object{
	var reqObj:Object = new Object();
	reqObj['srcTabNo'] = 9;
	reqObj['fund.fundCode'] = fundCode.text; 
	reqObj['fund.fundName'] = fundName.text;
	reqObj['fund.officeId'] = StringUtil.trim(officeId.selectedItem.toString());
	reqObj['fund.swiftReceiveOfficeId'] = StringUtil.trim(this.swiftReceiveOfficeId.selectedItem.toString());
	reqObj['fund.copyInstructionType'] = StringUtil.trim(copyInstructionType.selectedItem.value); 
	reqObj['fund.instructionCopyRcvBic'] = StringUtil.trim(instructionCopyRcvBic.text);
	reqObj['fund.fundCategory'] = StringUtil.trim(fundCategory.selectedItem.value); 
	reqObj['fund.baseCurrency'] = baseCurrency.ccyText.text; 
	reqObj['fund.trialBalanceId'] = StringUtil.trim(this.mode == "entry"|| this.mode == "copy" ? fundCode.text:this.xml.fund.trialBalanceId);
	reqObj['fund.lmPositionCustody'] = StringUtil.trim(lmPositionCustody.selectedItem.value);
	reqObj['fund.startDateStr'] = startDateStr.text;
	reqObj['fund.closeDateStr'] = closeDateStr.text;
	reqObj['fund.taxFeeInclusion'] = StringUtil.trim(taxFeeInclusion.selectedItem.value);
	reqObj['fund.iconRequired'] = StringUtil.trim(iconRequired.selectedItem.value);
	reqObj['fund.gemsRequired'] = StringUtil.trim(gemsRequired.selectedItem.value);
	//reqObj['fund.int1Required'] = StringUtil.trim(int1Required.selectedItem.value);
	reqObj['fund.fundCategory'] = StringUtil.trim(fundCategory.selectedItem.value);
	reqObj['fund.lmImValidationFlag']=lmImValdationReqd.selectedItem.value;
	reqObj['fund.shortSellFlag'] = StringUtil.trim(shortSellFlag.selectedItem.value);
	//reqObj['fund.rtfpRequired'] = StringUtil.trim(rtfpRequired.selectedItem.value);
	reqObj['fund.formaRequired'] = StringUtil.trim(formaRequired.selectedItem.value);
	reqObj['fund.cashViewerReqd'] = StringUtil.trim(cashViewerRequired.selectedItem.value);
	reqObj['fund.fbpIfRequired'] = StringUtil.trim(fbpifRequired.selectedItem.value);
	reqObj['fund.instructionCxlFxReqd'] = StringUtil.trim(this.cxlForexTagReqd.selectedItem != null? this.cxlForexTagReqd.selectedItem.value: "");
	reqObj['fund.tfRequired'] = StringUtil.trim(tfRequired.selectedItem.value);
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
	
	//populate OfficeId List
	
	officeIdList = new ArrayCollection();
	officeIdList.addItem(" ");
	for each(xmlObj in xml.dropDownListValues.fundOfficeList.fundOffice){
		officeIdList.addItem(xmlObj);
	}
	officeId.selectedIndex = getIndex(officeIdList, xml.fund.officeId);

	//populate Swift Receive OfficeId List
	
	swiftReceiveOfficeIdList = new ArrayCollection();
	swiftReceiveOfficeIdList.addItem("");
	for each(xmlObj in xml.dropDownListValues.swiftReceiveOfficeList.swiftReceiveOffice){
		swiftReceiveOfficeIdList.addItem(xmlObj);
	}
	swiftReceiveOfficeId.selectedIndex = getIndex(swiftReceiveOfficeIdList, xml.fund.swiftReceiveOfficeId);
	
	//populate Copy Instruction Type OfficeId List	
	copyInstructionTypeList = new ArrayCollection();
	copyInstructionTypeList.addItem({label:"", value:""});
	for each(xmlObj in xml.dropDownListValues.copyInstructionTypeList.item){
		copyInstructionTypeList.addItem(xmlObj);
	}
	copyInstructionType.selectedIndex = getIndexOfLabelValueBean(copyInstructionTypeList, xml.fund.copyInstructionType);
	
	//populate Fund Category List
	fundCategoryList = new ArrayCollection();
	fundCategoryList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.fundCategoryList.item){
		fundCategoryList.addItem(xmlObj);
	}
	fundCategory.selectedIndex = getIndexOfLabelValueBean(fundCategoryList, xml.fund.fundCategory);
	
	//populate Tax Fee Inclusion List
	
	taxFeeInclusionList = new ArrayCollection();
	for each(xmlObj in xml.dropDownListValues.taxFeeInclusionList.item){
		taxFeeInclusionList.addItem(xmlObj);
	}
	taxFeeInclusion.selectedIndex = getIndexOfLabelValueBean(taxFeeInclusionList, xml.fund.taxFeeInclusion);
	
	//populate Icon Required List
	if(xml.fund.iconRequired == null || xml.fund.iconRequired == ""){
		iconRequired.enabled = false;
	}
	else{
		iconRequired.enabled = true;
	}
	iconRequiredList = new ArrayCollection();
	iconRequiredList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.iconRequiredList.item){
		iconRequiredList.addItem(xmlObj);
	}
	//XenosAlert.info("Icon Required:'" + xml.fund.iconRequired + "'");
	
	iconRequired.selectedIndex = getIndexOfLabelValueBean(iconRequiredList, xml.fund.iconRequired);
	//XenosAlert.info("Icon Required Selected Index:" + iconRequired.selectedIndex);
	//populate Gems Required List
	
	gemsRequiredList = new ArrayCollection();
	gemsRequiredList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.gemsRequiredList.item){
		gemsRequiredList.addItem(xmlObj);
	}
	gemsRequired.selectedIndex = getIndexOfLabelValueBean(gemsRequiredList, xml.fund.gemsRequired);
	
	//populate Int1Required List
	/*
	int1RequiredList = new ArrayCollection();
	int1RequiredList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.int1RequiredList.item){
		int1RequiredList.addItem(xmlObj);
	}
	int1Required.selectedIndex = getIndexOfLabelValueBean(int1RequiredList, xml.fund.int1Required);
	*/
	// Populate LM Position Custody List
	lmPositionCustodyList = new ArrayCollection();
	lmPositionCustodyList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.LmPositionCustodyFlagList.item){
		lmPositionCustodyList.addItem(xmlObj);
	}
	lmPositionCustody.selectedIndex = getIndexOfLabelValueBean(lmPositionCustodyList, xml.fund.lmPositionCustody);
	
	//populate Forma Required List
	formaRequiredList = new ArrayCollection();
	formaRequiredList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.formaRequiredList.item){
		formaRequiredList.addItem(xmlObj);
	}
	formaRequired.selectedIndex = getIndexOfLabelValueBean(formaRequiredList, xml.fund.formaRequired);
	
	//populate cash viewer Required List
	cashViewerRequiredList = new ArrayCollection();
	cashViewerRequiredList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.cashViewerRequiredList.item){
		cashViewerRequiredList.addItem(xmlObj);
	}
	cashViewerRequired.selectedIndex = getIndexOfLabelValueBean(cashViewerRequiredList, xml.fund.cashViewerReqd);
	
	//populate FBP IF Required List
	fbpifRequiredList = new ArrayCollection();
	//fbpifRequiredList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.fbpifRequiredList.item){
		fbpifRequiredList.addItem(xmlObj);
	}
	fbpifRequired.selectedIndex = getIndexOfLabelValueBean(fbpifRequiredList, xml.fund.fbpIfRequired);
	// Initialize Forex Instruction Information
	forexInstrInfo.init(xml);
	
	//Populate CXL Forex Tag Reqd
	cxlForexTagReqdList= new ArrayCollection();
	cxlForexTagReqdList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.cxlForexTagReqdList.item){
		cxlForexTagReqdList.addItem(xmlObj);
	}
	cxlForexTagReqd.selectedIndex = getIndexOfLabelValueBean(cxlForexTagReqdList, xml.fund.instructionCxlFxReqd);
	
	cxlForexTagReqd.enabled = forexInstrInfo.isListEmpty();
	forexInstrInfo.enabled = !XenosStringUtils.isBlank(xml.fund.instructionCxlFxReqd);
		
	lmImValidationRequiredList = new ArrayCollection();	
	for each(xmlObj in xml.dropDownListValues.lmImValidationFlagList.item){
		lmImValidationRequiredList.addItem(xmlObj);
	}
	lmImValdationReqd.selectedIndex = getIndexOfLabelValueBean(lmImValidationRequiredList, xml.fund.lmImValidationFlag.toString());
	
	//populate Short Sell Flag List
	shortSellFlagList = new ArrayCollection();
	shortSellFlagList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.shortSellFlagList.item){
		shortSellFlagList.addItem(xmlObj);
	}
	shortSellFlag.selectedIndex = getIndexOfLabelValueBean(shortSellFlagList, xml.fund.shortSellFlag);
	
	//populate RTFP Required List
	/*
	rtfpRequiredList = new ArrayCollection();
	rtfpRequiredList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.rtfpRequiredList.item){
		rtfpRequiredList.addItem(xmlObj);
	}
	rtfpRequired.selectedIndex = getIndexOfLabelValueBean(rtfpRequiredList, xml.fund.rtfpRequired);
	*/
	//populate Forma Required List
	
	fundCodeTypeList = new ArrayCollection();
	fundCodeTypeList.addItem({label:" ", value:" "});
	for each(xmlObj in xml.dropDownListValues.fundCodeTypeList.item){
		fundCodeTypeList.addItem(xmlObj);
	}
	fundCodeType.selectedIndex = getIndexOfLabelValueBean(fundCodeTypeList, xml.fundXref.fundCodeType);
	
	baseCurrency.ccyText.text = xml.fund.baseCurrency;
	
	fundCodeSummaryResult = new ArrayCollection();
	for each(xmlObj in xml.fundCrossRefsWrapper.fundCrossRefs){
		fundCodeSummaryResult.addItem(xmlObj);
	}
	for each(var obj:Object in fundCodeSummaryResult){
		if(obj.fundCodeType != "NAM")
			obj.isVisible=true;
	}
	fundCodeSummaryResult.refresh();
	startDateStr.text = xml.fund.startDateStr.toString();
	closeDateStr.text=xml.fund.closeDateStr.toString();
	//populate Thinkfolio Required List
	tfRequiredList = new ArrayCollection();
	for each(xmlObj in xml.dropDownListValues.tfRequiredList.item){
		tfRequiredList.addItem(xmlObj);
	}  
	
	onChangeFundCategory(false);

	onChangeLMOffice(false);
	
	if( ! XenosStringUtils.isBlank(xml.fund.tfRequired) ){
		tfRequired.selectedIndex = getIndexOfLabelValueBean(tfRequiredList, xml.fund.tfRequired);	
	}
	
	if((mode == 'amend' || mode == 'copy' || mode=="entry") && xml.account.defaultAccountFlag.toString()=="Y"){
	   fundConfirmation.includeInLayout = false;
	   fundConfirmation.visible=false;
	   fudEntryTab.includeInLayout = true;
	   fudEntryTab.visible=true;
	   if(mode=='amend'){
	    	fundCode.enabled = false;
	    	officeId.enabled =false;
	        	 
	    }
	}else{
	   fundConfirmation.removeAllChildren();
	   fundConfirmation.includeInLayout = true;
	   fundConfirmation.visible=true;
	   fudEntryTab.includeInLayout = false;
	   fudEntryTab.visible=false;
	   var fundTabConfirmationPage :accountFundConfiramtion = new accountFundConfiramtion();
	   fundTabConfirmationPage.setXml=xml;
	   fundConfirmation.addChild(fundTabConfirmationPage);
	}
	
	var reOpenFlag:String=xml.reopenFlag.toString();
	if(XenosStringUtils.equals(this.mode , "amend") || XenosStringUtils.equals(reOpenFlag , "true")) {
		if(xml.fund.isFundAmendable.toString() == 'N') {
	    	 	fundCategory.enabled = false;
	    	 	baseCurrency.enabled = false;
	    	 }			
	}  
	
	

}

override public function  validate():ValidationResultEvent{
	var model:Object = {
							accountFund:{
								fundCode:this.fundCode.text,
	                    		fundName:this.fundName.text,
	                    		officeId:this.officeId.selectedItem != null ? this.officeId.selectedItem : "",
	                    		fundCategory:this.fundCategory.selectedItem != null ? this.fundCategory.selectedItem.value : "",
	                    		baseCurrency:this.baseCurrency.ccyText.text,
	                    		lmPositionCustody:this.lmPositionCustody.text,
	                    		taxFeeInclusion:this.taxFeeInclusion.selectedItem != null ? this.taxFeeInclusion.selectedItem.value : "",
	                    		iconRequired:this.iconRequired.selectedItem != null ? this.iconRequired.selectedItem.value : "",
	                    		gemsRequired:this.gemsRequired.selectedItem != null ? this.gemsRequired.selectedItem.value : "",
	                    		//int1Required:this.int1Required.selectedItem != null ? this.int1Required.selectedItem.value : "",
	                    		formaRequired:this.formaRequired.selectedItem != null ? this.formaRequired.selectedItem.value : "",
	                    		cashViewerRequired:this.cashViewerRequired.selectedItem != null ? this.cashViewerRequired.selectedItem.value : "",
	                    		fbpifRequired:this.fbpifRequired.selectedItem != null ? this.fbpifRequired.selectedItem.value : "",
	                    		tfRequired:this.tfRequired.selectedItem != null ? this.tfRequired.selectedItem.value : "",
	                    		//rtfpRequired:this.rtfpRequired.selectedItem != null ? this.rtfpRequired.selectedItem.value : "",
	                    		startDateStr:this.startDateStr.text,
                                closeDateStr:this.closeDateStr.text,
                                instructionCopyRcvBic:StringUtil.trim(this.instructionCopyRcvBic.text),
                                copyInstructionType:this.copyInstructionType.selectedItem != null ? this.copyInstructionType.selectedItem.value : ''
	                		}
		                	}; 
		
	var validator:AccountFundTabValidator = new AccountFundTabValidator();
	validator.source = model;
	validator.property = "accountFund";
	/* if(!entryGrid.validateAllRecords(false)){
		return new ValidationResultEvent(ValidationResultEvent.INVALID);
	} */
	
	/* if(instrumentIdList==null || instrumentIdList.length<=0){
 		validator.results.push(new ValidationResult(true, 
                	"instrumentCode", "instrumentCode", "Please enter at least one instrument code."));
  	} */
	var validationResult:ValidationResultEvent = validator.validate(); 
	
	return validationResult;  
	//return new ValidationResultEvent(ValidationResultEvent.VALID);        	
}

/**
 * This method set the FORMA/GEMS/INT1 required value based on the Fund Category 
 */
private function onChangeFundCategory(onChange:Boolean):void{
	var fundCategoryVal:String = fundCategory.selectedItem.value;
	if(fundCategoryVal == " ") {
		gemsRequired.selectedIndex = 0;
		gemsRequired.enabled = false;

		//int1Required.selectedIndex = 0;
		//int1Required.enabled = false;

		formaRequired.selectedIndex = 0;
		formaRequired.enabled = false;
		
		cashViewerRequired.selectedIndex = 0;
		cashViewerRequired.enabled = false;

		//rtfpRequired.selectedIndex = 0;
		//rtfpRequired.enabled = false;
	}
	//
	if(onChange) {
		if(fundCategoryVal == "ADVISORY_FUND") {
			gemsRequired.selectedIndex = getIndexOfLabelValueBean(gemsRequiredList, "Y");
			gemsRequired.enabled = true;
			
			//int1Required.selectedIndex = getIndexOfLabelValueBean(int1RequiredList, "Y");
			//int1Required.enabled = true;

			formaRequired.selectedIndex = getIndexOfLabelValueBean(formaRequiredList, "N");
			formaRequired.enabled = false;
			
			//rtfpRequired.selectedIndex = getIndexOfLabelValueBean(rtfpRequiredList, "Y");
			//rtfpRequired.enabled = true;
			
			cashViewerRequired.selectedIndex = getIndexOfLabelValueBean(cashViewerRequiredList, "N");
			cashViewerRequired.enabled = false;
			
			lmPositionCustody.selectedIndex = getIndexOfLabelValueBean(lmPositionCustodyList, "N");

		}
		//
		if(fundCategoryVal == "MUTUAL_FUND") {
			
			gemsRequired.selectedIndex = getIndexOfLabelValueBean(gemsRequiredList, "N");
			gemsRequired.enabled = false;
			
			//int1Required.selectedIndex = getIndexOfLabelValueBean(int1RequiredList, "N");
			//int1Required.enabled = false;

			formaRequired.selectedIndex = getIndexOfLabelValueBean(formaRequiredList, "Y");
			formaRequired.enabled = true;
			
			cashViewerRequired.selectedIndex = getIndexOfLabelValueBean(cashViewerRequiredList, "Y");
			cashViewerRequired.enabled = true;
			
			//rtfpRequired.selectedIndex = getIndexOfLabelValueBean(rtfpRequiredList, "N");
			//rtfpRequired.enabled = false;
			
			lmPositionCustody.selectedIndex = getIndexOfLabelValueBean(lmPositionCustodyList, "Y");

		} 
	} else {
		if(fundCategoryVal == "ADVISORY_FUND") {
			
			formaRequired.selectedIndex = getIndexOfLabelValueBean(formaRequiredList, "N");
			formaRequired.enabled = false;
			
			cashViewerRequired.selectedIndex = getIndexOfLabelValueBean(cashViewerRequiredList, "N");
			cashViewerRequired.enabled = false;

		}
		//
		if(fundCategoryVal == "MUTUAL_FUND") {
			
			gemsRequired.selectedIndex = getIndexOfLabelValueBean(gemsRequiredList, "N");
			gemsRequired.enabled = false;
			
			//int1Required.selectedIndex = getIndexOfLabelValueBean(int1RequiredList, "N");
			//int1Required.enabled = false;
			
			//rtfpRequired.selectedIndex = getIndexOfLabelValueBean(rtfpRequiredList, "N");
			//rtfpRequired.enabled = false;

		} 
		
	}
} 

//This method set the ICON required value based on the LM office
private function onChangeLMOffice(onChange:Boolean):void {
    var lmOfficeVal:String = officeId.selectedItem.toString();

	if(lmOfficeVal ==" ") {
		iconRequired.selectedIndex = 0;
		iconRequired.enabled = false;
		tfRequired.selectedIndex = getIndexOfLabelValueBean(tfRequiredList, Globals.DATABASE_NO);
		tfRequired.enabled = false;
		
	}else if (onChange) {
		if(lmOfficeVal == "UK") {
			iconRequired.selectedIndex = getIndexOfLabelValueBean(iconRequiredList, Globals.DATABASE_YES);
			iconRequired.enabled = true;
			tfRequired.selectedIndex = getIndexOfLabelValueBean(tfRequiredList, Globals.DATABASE_YES);
			tfRequired.enabled = true;
	    } else  {
	    	iconRequired.selectedIndex = getIndexOfLabelValueBean(iconRequiredList, Globals.DATABASE_NO);
			iconRequired.enabled = true;
			tfRequired.selectedIndex = getIndexOfLabelValueBean(tfRequiredList, Globals.DATABASE_NO);
			tfRequired.enabled = true;
		}
	} else {
		iconRequired.enabled = true;
		tfRequired.enabled = true;
	}
}


/**
 * To add Fund Code Information
 */
private function addFundCode():void{
	var errorFlag:Boolean = false;
	var errorStr:String = "";
	if(XenosStringUtils.isBlank(fundCodeType.text)){
		errorFlag = true;
		errorStr += "Code Type can not be empty";
	}
    if(XenosStringUtils.isBlank(code.text)){
		errorFlag = true;
		errorStr += "\nID can not be empty";
	}
	if(errorFlag){
		XenosAlert.error(errorStr);
		return;
	}
	addFundCodeService.request = populateFundCode();
//	addFundCodeService.url = "ref/accountDispatch.action?method=addFundCodeInfo"
	addFundCodeService.send();
}

/**
 * To edit Fund Code Information
 */        
public function editFundCode(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.editIndexFundXref = fundCodeSummaryResult.getItemIndex(data);
	for each(var obj:Object in fundCodeSummaryResult){
		if(obj.fundCodeType != "NAM")
			obj.isVisible=true;
	}
	data.isVisible=false;
	fundCodeSummaryResult.refresh();
//	editFundCodeService.url = "ref/accountDispatch.action?method=editFundCodeInfo"
	editFundCodeService.request = reqObj;
	editFundCodeService.send();
}

/**
 * To delete Fund Code Information
 */         
public function deleteFundCode(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.editIndexFundXref = fundCodeSummaryResult.getItemIndex(data);
//	deleteFundCodeService.url = "ref/accountDispatch.action?method=deleteFundCodeInfo"
	deleteFundCodeService.request = reqObj;
	deleteFundCodeService.send();
}      

/**
 * To save Fund Code Information
 */         
public function saveFundCode():void{
	var errorFlag:Boolean = false;
	var errorStr:String = "";
	if(XenosStringUtils.isBlank(fundCodeType.text)){
		errorFlag = true;
		errorStr += "Code Type can not be empty";
	}
	if(XenosStringUtils.isBlank(code.text)){
		errorFlag = true;
		errorStr += "\nID can not be empty";
	}
	if(errorFlag){
		XenosAlert.error(errorStr);
		return;
	}
	var reqObj : Object = new Object();
//	saveFundCodeService.url = "ref/accountDispatch.action?method=updateFundCodeInfo"
	saveFundCodeService.request = populateEditedFundCode();
	saveFundCodeService.send();
}

/**
 * To cancel the edited Fund Code Information
 */         
private function cancelEditFundCode():void{
	var reqObj : Object = new Object();
//	cancelEditFundCodeService.url = "ref/accountDispatch.action?method=cancelFundCodeInfo"
	//cancelEditFundCodeService.request = populateEditedFundCode();
	cancelEditFundCodeService.send();
}

/**
 * Bind the fund code info to the request object
 */         
private function populateEditedFundCode():Object{
	var reqObj : Object = new Object();
	reqObj['fundXref.fundCodeType'] = this.fundCodeType.selectedItem != null ? this.fundCodeType.selectedItem.value : "";
	
	reqObj['fundXref.fundCode'] = this.code.text;
	
	return reqObj;
}
        
/**
* This method works as the result handler of the Submit Query Http Services.
* 
*/
public function fundCodeResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("fundCrossRefsWrapper").length()>0) {
			errPage.clearError(event);
			// if(this.mode != "AMEND")
            	fundCodeSummaryResult.removeAll(); 
			try {
			    for each ( var rec:XML in rs.fundCrossRefsWrapper.fundCrossRefs) {
			    	var fundCodeTypeStr:String = rec.fundCodeType.toString();
			    	trace("rec.fundCodeType :: " + rec.fundCodeType.toString());
			    	trace("rs.fundXref.defaultFundCodeType :: " + rs.fundXref.defaultFundCodeType.toString());
			    	if(fundCodeTypeStr != "NAM")
			    		rec.isVisible = true;
			    	else
			    		rec.isVisible = false;
 				    fundCodeSummaryResult.addItem(rec);
			    }
			    fundCodeType.selectedIndex = 0;
			    code.text = "";
			    editMode = false;
            	fundCodeSummaryResult.refresh();
            	fundCodeSummary.visible = true;
            	fundCodeSummary.includeInLayout = true;
			}catch(e:Error){
			    //XenosAlert.error(e.toString() + e.message);
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } 
		 else if(rs.child("Errors").length()>0) {
            //some error found
		 	//countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } 
		 else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	fundCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

/**
* This method works as the result handler of the Submit Query Http Services.
* 
*/
public function fundCodeEditResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		if(rs.child("fundCrossRefsWrapper").length()>0){
			editMode = true;
			code.text = rs.fundXref.fundCode;
			var selectedFundCodeType:String =rs.fundXref.fundCodeType.toString();
			fundCodeType.selectedIndex = getIndexOfLabelValueBean(fundCodeTypeList,selectedFundCodeType);
		} 
		else if(rs.child("Errors").length()>0) {
            //some error found
		 	fundCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } 
		 else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	fundCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    } 
}

private function populateFundCode():Object{
	var reqObj : Object = new Object();
	reqObj['fundXref.fundCodeType'] = this.fundCodeType.selectedItem != null ? this.fundCodeType.selectedItem.value : "";
	
	reqObj['fundXref.fundCode'] = this.code.text;
	
	return reqObj;
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

/**
 * This method is executed for any change
 * in the changeCxlForexTagReqd combo.
 */
 private function changeCxlForexTagReqd():void {
 	var value:String = cxlForexTagReqd.selectedItem != null ? cxlForexTagReqd.selectedItem.value : "";
 	if (XenosStringUtils.equals(value, 'Y')) {
 		forexInstrInfo.enabled = true;
 	} else if (forexInstrInfo.isListEmpty()){
 		forexInstrInfo.enabled = false;
 	}
 }

/**
 * This method is executed for any alteration 
 * in the list of forex instruction information
 */  
 private function alterForexInstrInfo():void {
 	
 	cxlForexTagReqd.enabled = forexInstrInfo.isListEmpty();
 	
 }
