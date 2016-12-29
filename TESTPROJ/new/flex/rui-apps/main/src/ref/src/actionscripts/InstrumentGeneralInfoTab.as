

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.CustomChangeEvent;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.validators.InstrumentGeneralInfoValidator;

import flash.events.FocusEvent;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.events.DropdownEvent;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
import mx.validators.ValidationResult;


[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]private var xml:XML = new XML();
[Bindable]private var categoryCodeSummaryResult:ArrayCollection = new ArrayCollection();
[Bindable]public var codeTypeList:ArrayCollection;
[Bindable]private var listedIdList:ArrayCollection;
[Bindable]private var priceTypeList:ArrayCollection;
[Bindable]private var editedInstrumentCode:XML = new XML();
[Bindable]public var categoryTypeList:ArrayCollection;

// data provider for Basic Attributes
[Bindable]public var issueStatusList:ArrayCollection;
[Bindable]public var issuerList:ArrayCollection;
[Bindable]public var whenIssuedFlagList:ArrayCollection;
[Bindable]public var defaultFormList:ArrayCollection;
[Bindable]public var dualListedFlagList:ArrayCollection;
[Bindable]public var defaultSettlementLocationList:ArrayCollection;

[Bindable]public var investmentSectorList:ArrayCollection;
[Bindable]public var mutualFundCategoryList:ArrayCollection;

[Bindable]public var instrumentInfoSummaryResult:ArrayCollection = new ArrayCollection();
[Bindable]public var languageCodeList:ArrayCollection;

[Bindable]public var categoryMap:Object =null;
[Bindable]public var isTypeCcy:Boolean = false;
[Bindable]private var urlModeBind:String="Entry";
[Bindable]private var instrumentIdList:ArrayCollection = new ArrayCollection();

[Bindable]public var warningMessageLst:ArrayCollection = new ArrayCollection();
private var isShowWarning:Boolean=true;
private var oldInstrumentType:String = XenosStringUtils.EMPTY_STR;
private var originalInvestmentCountryCode:String = XenosStringUtils.EMPTY_STR;
/* [Bindable]private var addServiceUrl:String="ref/instrumentEntryDispatch.action?method=addInstrumentCode";
[Bindable]private var editServiceUrl:String="ref/instrumentEntryDispatch.action?method=addInstrumentCode&editMode=true";
[Bindable]private var deleteServiceUrl:String="ref/instrumentEntryDispatch.action?method=deleteInstrumentCode" */;

[Bindable]private var instrumentCategory:ArrayCollection = new ArrayCollection();
[Bindable]private var categoryAddServiceUrl:String="ref/instrumentEntryDispatch.action?method=addCategory";
[Bindable]private var categoryEditServiceUrl:String="ref/instrumentEntryDispatch.action?method=addCategory&editMode=true";
[Bindable]private var categoryDeleteServiceUrl:String="ref/instrumentEntryDispatch.action?method=deleteCategory";

[Event(name="typeChangeEvent", type="com.nri.rui.core.controls.CustomChangeEvent")]


override public function set mode(modeStr:String):void{
	super.mode=modeStr;	
	if(modeStr=="amend"){
		urlModeBind="Amend";
	}
	else if(modeStr=="entry"){
		urlModeBind="Entry";
	}
}

override public function populateRequest():Object {
	
	trace("instrumentType :: " + instrumentType.itemCombo.text);
	var reqObj:Object = new Object();
	reqObj['instrumentCodeType'] = categoryType.selectedItem != null ? categoryType.selectedItem : "";
	
	reqObj['instrumentPage.contractSizeStr'] = contractSize.text; 
	reqObj['instrumentPage.countryCode'] = !isTypeCcy ? countryCode.countryCode.text : countryCodeForCcy.countryCode.text; 
	reqObj['instrumentPage.tradeCcy'] = issueCcy.ccyText.text; 
	if(isTypeCcy){
		reqObj['instrumentPage.displaySeqStr'] = displaySeq.text;
	}
	reqObj['instrumentPage.minTradingUnitStr'] = minTradingUnit.text; 
	reqObj['instrumentPage.listedId'] = StringUtil.trim(listedId.selectedItem.value); 
	reqObj['instrumentPage.priceUnit'] = StringUtil.trim(priceType.selectedItem.value); 
	reqObj['defaultShortName'] = shortName.text; 
	reqObj['defaultOfficialName'] = officialName.text; 
	reqObj['instrumentPage.instrumentType'] = instrumentType.itemCombo.text;
	
	reqObj['instrumentPage.listedDate'] = listedDate.text;
	reqObj['instrumentPage.delistedDate'] = deListedDate.text;
	reqObj['instrumentPage.auctionDateStr'] = auctionDate.text;
	reqObj['instrumentPage.issueStatus'] = StringUtil.trim(issueStatus.selectedItem.toString());
	reqObj['instrumentPage.issuer'] = StringUtil.trim(issuer.selectedItem.value);
	reqObj['instrumentPage.whenIssuedFlag'] = StringUtil.trim(whenIssuedFlag.selectedItem.value);
	reqObj['instrumentPage.issueQuantityStr'] = issueQuantity.text;
	reqObj['instrumentPage.outstandingQuantityStr'] = outstandingQuantity.text;
	reqObj['instrumentPage.defaultDeliveryMethod'] = StringUtil.trim(defaultForm.selectedItem.value);
	reqObj['instrumentPage.transferAgentCode'] = transferAgent.finInstCode.text;
	reqObj['instrumentPage.dualListed'] = StringUtil.trim(dualListedFlag.selectedItem.value);
	reqObj['instrumentPage.defaultSettlementLocation'] = StringUtil.trim(defaultSettlementLocation.selectedItem.value);
	reqObj['instrumentPage.investmentCountryCode'] = investmentCountryCode.countryCode.text;
	if(this.mode == "amend"){
		reqObj['instrumentPage.originalInvestmentCountryCode'] = originalInvestmentCountryCode;		
	}
	reqObj['instrumentPage.investmentSector'] = StringUtil.trim(investmentSector.selectedItem.value);
	reqObj['instrumentPage.mutualFundCategory'] = StringUtil.trim(mutualFundCategory.selectedItem.value);
	
	if(this.mode == "entry")
		reqObj['SCREEN_KEY'] = 20;
	else 
		reqObj['SCREEN_KEY'] = 25;
	return reqObj;
}

override public function reset():void {

}

override public function  initPage(response:XML):void{

	xml = response as XML;
	
//	try{
		errPage.removeError();
//	}catch(e:Error){
//		
//	}
	
	if(xml.instrumentPage.instrumentType == "CCY"){
		isTypeCcy = true;
	}else{
		isTypeCcy = false;
	}
	
	
	
	//instrument code grid refresh
	//XenosAlert.info(xml.instrumentCrossRefsWrapper.children().length().toString());
	if(xml.instrumentCrossRefsWrapper.children().length()>0){
		instrumentIdList.removeAll(); 
		for each (var rec1:XML in xml.instrumentCrossRefsWrapper.instrumentCrossRefs ) {
			rec1.isDeleteEnabled = true;					
			if(this.mode=="amend" && (rec1.instrumentCodeType.toString()==	xml.defaultInstrumentCodeType.toString())){
				rec1.isDeleteEnabled = false;
			}
		    instrumentIdList.addItem(rec1);
		 }
	}else{
		instrumentIdList.removeAll(); 
	}	
	instrumentIdList.refresh();
	
	//Instrument Code Type
	var indx:int=0;
	var i:int=0;
	codeTypeList = new ArrayCollection();	
	for each(var xmlObj:Object in xml.instrumentCodeTypesWrapper.instrumentCodeType){
		if(XenosStringUtils.equals(xml.defaultInstrumentCodeType.toString(),xmlObj.toString())){
			indx=i;
		}				
		codeTypeList.addItem(xmlObj);
		i++;
	}
	codetype.selectedIndex = indx;
	
	//Instrument Type
	//If mode is amend disable instrument type selection
	instrumentType.itemCombo.text = xml.instrumentPage.instrumentType;
	oldInstrumentType = xml.instrumentPage.instrumentType;
	//if(this.mode=="amend"){
		//instrumentType.enabled=false;		
	//}
	
	languageCodeList = new ArrayCollection();
	for each(var xmlObj:Object in xml.charsetCodeValuesWrapper.charsetCodeValues){
		languageCodeList.addItem(xmlObj);
	}
	
	//Contract Size
	contractSize.text = xml.instrumentPage.contractSizeStr;
	
	
	//display sequence
	displaySeq.text = xml.instrumentPage.displaySeqStr;
	//Country Code
	if(!isTypeCcy)
		countryCode.countryCode.text = xml.instrumentPage.countryCode;
	else
		countryCodeForCcy.countryCode.text = xml.instrumentPage.countryCode;
	//Issue Ccy
	issueCcy.ccyText.text = xml.instrumentPage.tradeCcy;
	
	//Investment Country Code
	investmentCountryCode.countryCode.text=xml.instrumentPage.investmentCountryCode;
	originalInvestmentCountryCode=xml.instrumentPage.investmentCountryCode;
	//Minimum Trading Unit
	minTradingUnit.text = xml.instrumentPage.minTradingUnitStr;
	
	//Listed ID
	listedIdList = new ArrayCollection();
	for each(var xmlObj:Object in xml.instrumentPage.listedIdValue.item){
		listedIdList.addItem(xmlObj);
	}
	listedId.selectedIndex = getIndexOfLabelValueBean(listedIdList, xml.instrumentPage.listedId);
	
	//Price Type
	priceTypeList = new ArrayCollection();
	for each(var xmlObj:Object in xml.instrumentPage.priceTypeValue.item){
		priceTypeList.addItem(xmlObj);
	}
	priceType.selectedIndex = getIndexOfLabelValueBean(priceTypeList, xml.instrumentPage.priceUnit);
	
	//Listed Date
	listedDate.text = xml.instrumentPage.listedDate;
	
	//Delisted Date
	deListedDate.text = xml.instrumentPage.delistedDate;
	
	//Auction Date
	auctionDate.text = xml.instrumentPage.auctionDateStr;
	
	//Issue Status
	issueStatusList = new ArrayCollection();
	issueStatusList.addItem(" ");
	for each(var xmlObj:Object in xml.instrumentPage.IssueStatusValuesList.IssueStatusValues){
		issueStatusList.addItem(xmlObj);
	}
	issueStatus.selectedIndex = getIndex(issueStatusList, xml.instrumentPage.issueStatus);
	
	//Issuer
	issuerList = new ArrayCollection();
	issuerList.addItem({label:" ", value:" "});
	for each(var xmlObj:Object in xml.instrumentPage.issuerPkIdValue.item){
		issuerList.addItem(xmlObj);
	}
	issuer.selectedIndex = getIndexOfLabelValueBean(issuerList, xml.instrumentPage.issuer);
	
	//When Issued Flag
	whenIssuedFlagList = new ArrayCollection();
	for each(var xmlObj:Object in xml.instrumentPage.WhenIssuedFlagValues.item){
		whenIssuedFlagList.addItem(xmlObj);
	}
	whenIssuedFlag.selectedIndex = getIndexOfLabelValueBean(whenIssuedFlagList, xml.instrumentPage.whenIssuedFlag);
	
	//Issue Quantity
	issueQuantity.text = xml.instrumentPage.issueQuantityStr;
	
	//Outstanding Quantity
	outstandingQuantity.text = xml.instrumentPage.outstandingQuantityStr;
	
	//Delivery Form
	defaultFormList = new ArrayCollection(); 
	defaultFormList.addItem({label:" ", value:" "});
	for each(var xmlObj:Object in xml.instrumentPage.defaultDeliveryMethodList.item) {
		defaultFormList.addItem(xmlObj);
	}
	defaultForm.selectedIndex = getIndexOfLabelValueBean(defaultFormList, xml.instrumentPage.defaultDeliveryMethod);
	
	//Transfer Agent
	transferAgent.finInstCode.text = xml.instrumentPage.transferAgentCode;
	
	//Dual Listed Flag
	dualListedFlagList = new ArrayCollection();
	dualListedFlagList.addItem({label:" ", value:" "});
	for each(var xmlObj:Object in xml.instrumentPage.DualListedFlagValuesList.item){
		dualListedFlagList.addItem(xmlObj);
	}
	dualListedFlag.selectedIndex = getIndexOfLabelValueBean(dualListedFlagList, xml.instrumentPage.dualListed);
	
	//Default Settlement Location
	defaultSettlementLocationList = new ArrayCollection();
	defaultSettlementLocationList.addItem({label:" ", value:" "});
	for each(var xmlObj:Object in xml.instrumentPage.defaultSettlementLocationList.item){
		defaultSettlementLocationList.addItem(xmlObj);
	}
	defaultSettlementLocation.selectedIndex = getIndexOfLabelValueBean(defaultSettlementLocationList, xml.instrumentPage.defaultSettlementLocation);
	
	//investment sector
	investmentSectorList = new ArrayCollection();
	investmentSectorList.addItem({label:" ", value:" "});	
	for each(var xmlObj:Object in xml.instrumentPage.investmentSectorList.item){		
		investmentSectorList.addItem(xmlObj);
		
	}
	investmentSector.selectedIndex = getIndexOfLabelValueBean(investmentSectorList, xml.instrumentPage.investmentSector);
	
	//fund category 
	mutualFundCategoryList = new ArrayCollection();
	mutualFundCategoryList.addItem({label:" ", value:" "});
	for each(var xmlObj:Object in xml.instrumentPage.mutualFundCategoryList.item){
		mutualFundCategoryList.addItem(xmlObj);
	}
	mutualFundCategory.selectedIndex = getIndexOfLabelValueBean(mutualFundCategoryList, xml.instrumentPage.mutualFundCategory);
	
	
	//categoryType	
	categoryTypeList = new ArrayCollection();
	if(categoryTypeList.length==0){
		categoryTypeList.addItem("");
		for each(var xmlObj:Object in xml.categoryTypesList.categoryTypes){
			categoryTypeList.addItem(xmlObj);
		}
	}
	categoryType.selectedIndex = 0;
	//category grid data refresh
	
	categoryCodeSummaryResult = new ArrayCollection();
	for each(var xmlObj:Object in xml.categoriesWrapper.categories){
		xmlObj.isVisible = true;
		categoryCodeSummaryResult.addItem(xmlObj);
	}
	
	//populate category Map
	var tmpList:ArrayCollection=null;
	if(categoryMap==null){
		categoryMap=new Object();		
		for each(var xmlObj:Object in xml.getCategoryTypeIdMap.item.entry){
			tmpList=new ArrayCollection();
			tmpList.addItem("");			
			for each(var obj:Object in xmlObj.Messages.Message){
				tmpList.addItem(obj);
			}
			categoryMap[xmlObj.key]=tmpList;
		}
	}
	
	//Language Code
	languageCode.text = xml.defaultCharsetCode;
	//Short Name
	shortName.text = xml.defaultShortName;
	//Official Name
	officialName.text = xml.defaultOfficialName;
	
	//For Detail Instrument Info
	shortNameInfo.text=xml.shortName;
	officialNameInfo.text=xml.officialName;
	
	instrumentInfoSummaryResult = new ArrayCollection();
	for each(var xmlObj:Object in xml.instrumentNameCrossRefsWrapper.instrumentNameCrossRefs) {
		xmlObj.isVisible = true;
 		instrumentInfoSummaryResult.addItem(xmlObj);
	}
	
	instrumentType.itemCombo.addEventListener(DropdownEvent.CLOSE, instrumentTypeSelectionChangeHandler);
	if(!isShowWarning){
		warningMessageLst = new ArrayCollection();
		populateWarningMessage();
	}               
	
	// Populate Instrument Memo
	this.memoPopulator.init(xml);
	
} 

private function instrumentTypeSelectionChangeHandler(e:DropdownEvent):void{
	//trace("instrumentTypeSelectionChangeHandler");
	if (!XenosStringUtils.isBlank(instrumentType.itemCombo.text)) {
		if(this.mode == "amend"){
			var instrumentObj:Object = new Object();
			instrumentObj.oldInstrumentType = oldInstrumentType;
			instrumentObj.newInstrumentType = instrumentType.itemCombo.text;
			instrumentType.dispatchEvent(new CustomChangeEvent("typeChangeEvent", instrumentObj, instrumentType,true));
		}else{
			instrumentType.dispatchEvent(new CustomChangeEvent("typeChangeEvent", instrumentType.itemCombo.text, instrumentType,true));
		}
	}
}

private function loadAll():void{
	//reset();
	instrumentType.setFocus();
	if(isShowWarning){
		populateWarningMessage();
    	isShowWarning=false;
 	}
}

private function populateWarningMessage():void{	
	for each(var warningObj:Object in xml.softExceptionList.item) {
		warningMessageLst.addItem(warningObj.value);
	}
    softWarn.showWarning(warningMessageLst);
}

override public function  validate():ValidationResultEvent{	
	var countryCodeStr:String;
	var invsetmentCountryCodeStr:String;
	if(!isTypeCcy){
		countryCodeStr = countryCode.countryCode.text;
		invsetmentCountryCodeStr=investmentCountryCode.countryCode.text;
	}
	else{
		countryCodeStr = countryCodeForCcy.countryCode.text;
		invsetmentCountryCodeStr=investmentCountryCode.countryCode.text;
	}
	var model:Object = {
							instrument:{
								instrumentType:this.instrumentType.itemCombo.text,
	                    		contractSize:this.contractSize.text,
	                    		countryCode:countryCodeStr,
	                    		investmentCountryCode:invsetmentCountryCodeStr,
	                    		issueCcy:this.issueCcy.ccyText.text,
	                    		displaySequence:this.displaySeq.text,
	                    		minTradingUnit:this.minTradingUnit.text,
	                    		officialName:this.officialName.text,
	                    		shortName:this.shortName.text,
	                    		listedId:this.listedId.selectedItem != null ? this.listedId.selectedItem.value : "",
	                    		priceType:this.priceType.selectedItem != null ? this.priceType.selectedItem.value : ""
	                		}
		                	};
		
		var validator:InstrumentGeneralInfoValidator = new InstrumentGeneralInfoValidator();
		validator.source = model;
		validator.property = "instrument";
		/* if(!entryGrid.validateAllRecords(false)){
			return new ValidationResultEvent(ValidationResultEvent.INVALID);
		} */
		
		if(instrumentIdList==null || instrumentIdList.length<=0){
 			validator.results.push(new ValidationResult(true, 
                    	"instrumentCode", "instrumentCode", "Please enter at least one instrument code."));
  		}
		var validationResult:ValidationResultEvent = validator.validate(); 
		
		return validationResult;    	
}

/**
 * To add Country Code Information
 */
private function addInstrumentCode():void{
	if(XenosStringUtils.isBlank(categoryType.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.categorytype'));
		return;
	}else if(XenosStringUtils.isBlank(categoryId.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.categoryid'));
		return;
	}
	addInstrumentCodeService.request = populateCategory();
	/* if(this.mode == "AMEND")
		addInstrumentCodeService.url = "ref/countryAmendDispatch.action?method=addCountryCode"
	else */
	addInstrumentCodeService.url = "ref/instrument"+urlModeBind+"Dispatch.action?method=addCategory"
	addInstrumentCodeService.send();
}

public function editCategory(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = categoryCodeSummaryResult.getItemIndex(data);
	categoryCodeSummaryResult.removeItemAt(reqObj.rowNo);
	//data.isVisible=false;
	categoryCodeSummaryResult.refresh();
	/* if(this.mode == "AMEND")
		editInstrumentCodeService.url = "ref/countryAmendDispatch.action?method=editCountryCodeInfo"
	else */
	editInstrumentCodeService.url = "ref/instrument"+urlModeBind+"Dispatch.action?method=editCategory"
	editInstrumentCodeService.request = reqObj;
	editInstrumentCodeService.send();
}

 public function deleteCategory(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = categoryCodeSummaryResult.getItemIndex(data);
	/* if(this.mode == "AMEND")
		deleteInstrumentCodeService.url = "ref/countryAmendDispatch.action?method=deleteCountryCodeInfo"
	else */
	deleteInstrumentCodeService.url = "ref/instrument"+urlModeBind+"Dispatch.action?method=deleteCategory"
	deleteInstrumentCodeService.request = reqObj;
	deleteInstrumentCodeService.send();
}



public function saveInstrumentCode():void{
	if(XenosStringUtils.isBlank(categoryId.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.missing.instrumentcode'));
		return;
	}
	
	var reqObj : Object = new Object();
	/* if(this.mode == "AMEND")
		saveInstrumentCodeService.url = "ref/countryAmendDispatch.action?method=updateCountryCodeInfo"
	else */
	saveInstrumentCodeService.url = "ref/instrument"+urlModeBind+"Dispatch.action?method=addCategory"
	saveInstrumentCodeService.request = populateEditedInstrumentCode();
	saveInstrumentCodeService.send();
}

private function cancelEditInstrumentCode():void{
	var reqObj : Object = new Object();
	/* if(this.mode == "AMEND")
		cancelEditInstrumentCodeService.url = "ref/countryAmendDispatch.action?method=cancelCountryCodeInfo"
	else */
	cancelEditInstrumentCodeService.url = "ref/countryDispatch.action?method=cancelCountryCodeInfo"
	cancelEditInstrumentCodeService.request = populateEditedInstrumentCode();
	cancelEditInstrumentCodeService.send();
}

private function populateEditedInstrumentCode():Object{
	var reqObj : Object = new Object();
	reqObj['countryCrossRef.countryCodeType'] = this.categoryType.text;
	
	reqObj['countryCrossRef.countryCode'] = this.categoryId.text;
	
	return reqObj;
}

/**
* This method works as the result handler of the Submit Query Http Services.
* 
*/
public function InstrumentCodeResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		 if(rs.child("instrumentCrossRefsWrapper").length()>0) {
			errPage.clearError(event);
			// if(this.mode != "AMEND")
            	categoryCodeSummaryResult.removeAll(); 
			try {
			    for each ( var rec:XML in rs.categoriesWrapper.categories ) {
			    	rec.isVisible = true;
 				    categoryCodeSummaryResult.addItem(rec);
			    }
			    //codeGrid.visible = true;
			    //codeGrid.includeInLayout = true;
			    categoryType.selectedIndex = 0;
			    categoryId.text = "";
			    //editedCodeGrid.visible = false;
			    //editedCodeGrid.includeInLayout = false;
            	categoryCodeSummaryResult.refresh();
            	/* categorySummary.visible = true;
            	categorySummary.includeInLayout = true; */
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
		 	categoryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
    
}

/**
* This method works as the result handler of the Submit Query Http Services.
* 
*/
public function InstrumentCodeEditResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		if(rs.child("categoriesWrapper").length()>0){
			editedInstrumentCode = rs;
			//codeGrid.visible = false;
			//codeGrid.includeInLayout = false;
			//editedCodeGrid.visible = true;
			//editedCodeGrid.includeInLayout = true;
			for(var i:int=0; i<categoryTypeList.length; i++){
				if(categoryTypeList.getItemAt(i) == rs.categoryType.toString()){
					categoryType.selectedIndex = i;
				}
			}
			categoryId.dataProvider = categoryMap[categoryType.selectedItem];
			var categoryTypeCol:ArrayCollection = categoryMap[categoryType.selectedItem] as ArrayCollection;
			for(var i:int=0; i<categoryTypeCol.length; i++){
				if(categoryTypeCol.getItemAt(i) == rs.categoryId.toString()){
					categoryId.selectedIndex = i;
				}
			}
		} else if(rs.child("Errors").length()>0) {
            //some error found
		 	categoryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	categoryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
    
}

private function populateCategory():Object{
	var reqObj : Object = new Object();
	reqObj['categoryType'] = this.categoryType.selectedItem != null ? this.categoryType.selectedItem : "";
	
	reqObj['categoryId'] = this.categoryId.selectedItem != null ? this.categoryId.selectedItem : "";
	
	return reqObj;
}

private function validateNumber(event:FocusEvent):void{
	numVal1.source = TextInput(event.currentTarget);
	numVal1.handleNumericField(numberFormatter);
}

/**
 * This method will validate contract size on focus out. 
 * As focus out is not called during submit press so separate validation has been added in server side also
 */
 
private function validateContractSize(event:FocusEvent):void{
	contractSizeValidator.source = TextInput(event.currentTarget);
	contractSizeValidator.handleNumericField(numberFormatter);
}

override public function  controlStateChangeHandler():void {
	//instrumentType.enabled = false;
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


private function visibleInstrumentInfo():void{
	if(XenosStringUtils.isBlank(shortName.text)){			
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.missing.shortname'));
		visibleInstrumentInfoBtn.selected=false;
	}else if(XenosStringUtils.isBlank(officialName.text)){		
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.mising.officialname'));
		visibleInstrumentInfoBtn.selected=false;
	}else if(visibleInstrumentInfoBtn.selected){
		ws.includeInLayout=true;
		ws.visible=true;
	}else if(!visibleInstrumentInfoBtn.selected){
		ws.includeInLayout=false;
		ws.visible=false;
	}
}

/**
 * To add Memo Information
 */
private function addInstrumentInfo():void{
	if(XenosStringUtils.isBlank(languageCodeInfo.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.missing.langcode'));
		return;
	}else if(XenosStringUtils.isBlank(shortNameInfo.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.shortname'));
		return;
	}else if(XenosStringUtils.isBlank(officialNameInfo.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.officialname'));
		return;
	}
	addInstrumentInfoService.request = populateInstrumentInfo();
	/* if(this.mode == "AMEND")
		addRestrictionService.url = "ref/instrumentEntryDispatch.action?method=addMemo
	else */
	addInstrumentInfoService.url = "ref/instrument"+urlModeBind+"Dispatch.action?method=addInstrumentName"
	addInstrumentInfoService.send();
}

public function editInstrumentInfo(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = instrumentInfoSummaryResult.getItemIndex(data);
	instrumentInfoSummaryResult.removeItemAt(reqObj.rowNo);
	//data.isVisible=false;
	instrumentInfoSummaryResult.refresh();
	/* if(this.mode == "AMEND")
		editRestrictionService.url = "ref/instrumentEntryDispatch.action?method=editRestriction"
	else */
	editInstrumentInfoService.url = "ref/instrument"+urlModeBind+"Dispatch.action?method=editInstrumentName"
	editInstrumentInfoService.request = reqObj;
	editInstrumentInfoService.send();
}

 public function deleteInstrumentInfo(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = instrumentInfoSummaryResult.getItemIndex(data);
	/* if(this.mode == "AMEND")
		deleteRestrictionService.url = "ref/instrumentEntryDispatch.action?method=deleteRestriction"
	else */
	deleteInstrumentInfoService.url = "ref/instrument"+urlModeBind+"Dispatch.action?method=deleteInstrumentName"
	deleteInstrumentInfoService.request = reqObj;
	deleteInstrumentInfoService.send();
}


/**
* This method works as the result handler of the Submit Query Http Services for Memos.
* 
*/
public function InstrumentInfoResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		 if(rs.child("charsetCodeValuesWrapper").length()>0) {
		 	
			errPage.clearError(event);
			// if(this.mode != "AMEND")
            	instrumentInfoSummaryResult.removeAll(); 
			try {
			    for each ( var rec:XML in rs.instrumentNameCrossRefsWrapper.instrumentNameCrossRefs ) {
			    	rec.isVisible = true;
 				    instrumentInfoSummaryResult.addItem(rec);
			    }
			    
			    shortNameInfo.text = "";
			    officialNameInfo.text ="";
			   
            	instrumentInfoSummaryResult.refresh();
            	
			}catch(e:Error){
			    //XenosAlert.error(e.toString() + e.message);
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } else if(rs.child("Errors").length()>0) {
           
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	instrumentInfoSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
    
}

/**
* This method works as the result handler of the Submit Query Http Services for Memos.
* 
*/
public function InstrumentInfoEditResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		if(rs.child("charsetCodeValuesWrapper").length()>0){
			
//			editedMemoList = rs;
			
			for(var i:int=0; i<languageCodeList.length; i++){			
				if(languageCodeList.getItemAt(i).toString() == rs.charsetCode.toString()){
					languageCodeInfo.selectedIndex = i;
				}
			}
			
			shortNameInfo.text=rs.shortName.toString();
			officialNameInfo.text=rs.officialName.toString();
			
		} else if(rs.child("Errors").length()>0) {
            //some error found
		 	instrumentInfoSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	instrumentInfoSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
}

private function populateInstrumentInfo():Object{
	
	var reqObj : Object = new Object();
	reqObj['charsetCode'] = this.languageCodeInfo.selectedItem != null ? this.languageCodeInfo.selectedItem.toString() : "";
	
	reqObj['shortName'] = this.shortNameInfo.text != null ? this.shortNameInfo.text : "";
	
	reqObj['officialName'] = this.officialNameInfo.text != null ? this.officialNameInfo.text : "";
	
	return reqObj;
}

private function doinstrumentCodeAdd():void{
	if(XenosStringUtils.isBlank(instrumentId.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.instrumentcode'));
	}
	else{
		var reqObj:Object=new Object();
		reqObj.instrumentCodeType=codetype.selectedLabel;
		reqObj.securityId=instrumentId.text;
		reqObj.default=enterpriseDefault.selected;
		
		addInstrumentService.url="ref/instrument"+urlModeBind+"Dispatch.action?method=addInstrumentCode";
		addInstrumentService.request=reqObj;
		addInstrumentService.send();
	}
}

private function addInstrumentServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("instrumentCrossRefsWrapper").length()>0) {
			errPage.clearError(event);			
            instrumentIdList.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.instrumentCrossRefsWrapper.instrumentCrossRefs) {
			    	rec.isDeleteEnabled = true;					
					if(this.mode=="amend" && (rec.instrumentCodeType.toString()==rs.defaultInstrumentCodeType.toString())){
						rec.isDeleteEnabled = false;
					}			    	
 				    instrumentIdList.addItem(rec); 				    
			    }		   
            	instrumentIdList.refresh();
            	
            	for(var i:int=0;i<codeTypeList.length;i++){
            		if(rs.defaultInstrumentCodeType.toString()==codeTypeList.getItemAt(i).toString()){
            			codetype.selectedIndex=i;
            			break;
            		}
            	}
            	
            	instrumentId.text="";
            	enterpriseDefault.selected=false;
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } else if(rs.child("Errors").length()>0) {
           	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	instrumentIdList.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

public function doinstrumentCodeEdit(data:Object):void{
	editInstrumentService.url="ref/instrument"+urlModeBind+"Dispatch.action?method=editInstrumentCode";
	var reqObj:Object=new Object();
	reqObj.rowNo=instrumentIdList.getItemIndex(data);
	editInstrumentService.request=reqObj;
	editInstrumentService.send();
}
private function editInstrumentServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("instrumentCrossRefsWrapper").length()>0) {
			errPage.clearError(event);			
            instrumentIdList.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.instrumentCrossRefsWrapper.instrumentCrossRefs) {
					rec.isDeleteEnabled = true;					
					if(this.mode=="amend" && (rec.instrumentCodeType.toString()==rs.defaultInstrumentCodeType.toString())){
						rec.isDeleteEnabled = false;
					}		    	
 				    instrumentIdList.addItem(rec); 				    
			    }			    
			    			    		   
            	instrumentIdList.refresh();
            	for(var i:int=0;i<codeTypeList.length;i++){
            		if(rs.instrumentCodeType.toString()==codeTypeList.getItemAt(i).toString()){
            			codetype.selectedIndex=i;
            			break;
            		}
            	}
            	
            	instrumentId.text=rs.securityId.toString();
            	enterpriseDefault.selected=(rs.default.toString()=='true')?true:false;
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } else if(rs.child("Errors").length()>0) {
           	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	instrumentIdList.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}
public function doinstrumentCodeDelete(data:Object):void{
	editInstrumentService.url="ref/instrument"+urlModeBind+"Dispatch.action?method=deleteInstrumentCode";
	var reqObj:Object=new Object();
	reqObj.rowNo=instrumentIdList.getItemIndex(data);
	editInstrumentService.request=reqObj;
	editInstrumentService.send();
}
