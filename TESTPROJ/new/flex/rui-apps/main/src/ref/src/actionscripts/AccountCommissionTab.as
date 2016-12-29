

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
   
[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]public var xml:XML;
[Bindable]private var taxIdCommissionList:ArrayCollection;
[Bindable]private var calcMethodList:ArrayCollection;
[Bindable]private var buySellFlgList:ArrayCollection;
[Bindable]private var rateTypeList:ArrayCollection;
[Bindable]private var slidingList:ArrayCollection;
[Bindable]private var prcSlidingList:ArrayCollection;
[Bindable]private var acctComissionList:ArrayCollection;
private var errList :ArrayCollection =null;
[Bindable]private var urlModeBind:String="";
private static var CP_INTERNAL:String="INTERNAL";
private static var CP_BANKCUST:String="BANK/CUSTODIAN";
private static var CP_BROKER:String="BROKER";


override public function populateRequest():Object{
	var reqObj:Object = new Object();
	return reqObj;
}

override public function reset():void {
}

override public function initPage(response:XML):void {
	xml = response as XML;
	// Set Url Mode 
	setURLModeBind(xml);
	// Populate the Data into page
	initializeAccountComisson(xml);
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

// Method populate the Data into the Page
	private function initializeAccountComisson(xmlObj:XML):void{
		// Account No field
		acctNo.text = xmlObj.accountNoExp;
		// Account Name field
		acctName.text = xmlObj.shortNameExp;
		
		//Commission ID/Name Combo
		taxIdCommissionList = new ArrayCollection();
		taxIdCommissionList.addItem({label: "" , value : ""});
		for each(var xmlTemp:Object in xmlObj.dropDownListValues.taxIdCommissionList.item){
			taxIdCommissionList.addItem(xmlTemp);
		}
		txidComison.selectedIndex = getIndexOfLabelValueBean(taxIdCommissionList, xmlObj.commissionTax.taxFeeId);
		
		//Calculation Method Combo
		calcMethodList = new ArrayCollection();
		calcMethodList.addItem("");
		for each(var xmlTemp1:Object in xmlObj.dropDownListValues.calculationMethodList.calculationMethod){
			calcMethodList.addItem(xmlTemp1);
		}
		calcMethod.selectedIndex = getIndex(calcMethodList, xmlObj.commissionTax.taxFeeCalcType.toString());
		
		// Issuer Country field
		issrCntry.countryCode.text = xmlObj.commissionTax.issueCountry;
		
		// Security Type field
		securityType.itemCombo.text = xmlObj.commissionTax.instrumentType;
		
		//Buy/Sell Combo
		buySellFlgList = new ArrayCollection();
		buySellFlgList.addItem({label: "" , value : ""});
		for each(var xmlTemp2:Object in xmlObj.dropDownListValues.buySellFlagList.item){
			buySellFlgList.addItem(xmlTemp2);
		}
		bsFlg.selectedIndex = getIndexOfLabelValueBean(buySellFlgList, xmlObj.commissionTax.buySellFlag);
		
		// Start Date field
		strtDate.text = xmlObj.commissionTax.ruleStartDateStr; 
		
		// End Date Field
		endDate.text = xmlObj.commissionTax.ruleEndDateStr; 
		
		// Rate filed
		rate.text = xmlObj.commissionTax.chargeRateStr; 
		
		// Rate Type Combo Box
		rateTypeList = new ArrayCollection();
		rateTypeList.addItem({label: "" , value : ""});
		for each(var xmlTemp3:Object in xmlObj.dropDownListValues.rateTypeList.item){
			rateTypeList.addItem(xmlTemp3);
		}
		rateType.selectedIndex = getIndexOfLabelValueBean(rateTypeList, xmlObj.commissionTax.rateType);
		
		// Max Value Field
		max.text = xmlObj.commissionTax.defaultMaxStr; 
		
		// Min Value Field
		min.text = xmlObj.commissionTax.defaultMinStr; 
		
		// Amount Value Field
		amt.text = xmlObj.commissionTax.chargeAmountStr; 
		
		// Unit Value Field
		unit.text = xmlObj.commissionTax.chargeUnitStr; 
		
		//Tab Field for Sliding Method Combo
		slidingList = new ArrayCollection();
		slidingList.addItem("");
		for each(var xmlTemp4:Object in xmlObj.dropDownListValues.chargeSlidingList.chargeSliding){
			slidingList.addItem(xmlTemp4);
		}
		sliding.selectedIndex = getIndex(slidingList, xmlObj.commissionTax.chargeSlidingTableId);
		
		//Tab Field for PRC Sliding Method Combo
		prcSlidingList = new ArrayCollection();
		prcSlidingList.addItem("");
		for each(var xmlTemp5:Object in xmlObj.dropDownListValues.chargePrcSlidingList.chargePrcSliding){
			prcSlidingList.addItem(xmlTemp5);
		}
		prcSliding.selectedIndex = getIndex(prcSlidingList, xmlObj.commissionTax.chargeSlidingTableIdPrc);
		
		// Discount Field
		discount.text = xmlObj.commissionTax.discountStr; 
		
		// Populate Account Commision List Data
		populateAcctComissionList(xmlObj);
		// Control the flow of the screen
		onChangeCommissionCalculationType();
		// Initialize Edit Index Comisson
		initializeditIndexCommission(xml)
	}

	// Control The visiblity of Add nd Update button
	private function initializeditIndexCommission(xmlObj:XML):void{
		var editIndex:int=0;
		editIndex= xmlObj.editIndexCommission;
		if(editIndex==-1){
			addIndx.includeInLayout=true;
			addIndx.visible=true;
			editIndx.includeInLayout=false;
			editIndx.visible=false;
		}else{
			addIndx.includeInLayout=false;
			addIndx.visible=false;
			editIndx.includeInLayout=true;
			editIndx.visible=true			
		}
	}

	private function hideAllCalculationTypeRelatedElements():void
	{
		IRate.includeInLayout = false;
		IRate.visible = false;
		IMinMax.includeInLayout = false;
		IMinMax.visible = false;
		ICharge.includeInLayout = false;
		ICharge.visible = false;
		IUnitLbl.includeInLayout = false;
		IUnitLbl.visible = false;
		IUnitFld.includeInLayout = false;
		IUnitFld.visible = false;
		IAmountLbl.includeInLayout = false;
		IAmountLbl.visible = false;
		IAmountFld.includeInLayout = false;
		IAmountFld.visible = false;
		ISliding.includeInLayout = false;
		ISliding.visible = false;		
	}
	// Method check which fields will be enable or diable depending on Calculation Method Value
	private function onChangeCommissionCalculationType():void
	{
	   hideAllCalculationTypeRelatedElements();
	    var calcMethodVal:String = calcMethod.selectedItem.toString();
	     switch (calcMethodVal)
	    {
	        case "FIXED_RATE":{
		        IRate.includeInLayout = true;
				IRate.visible = true;
				IMinMax.includeInLayout = true;
				IMinMax.visible = true;
				amt.text="";
				discount.text="";
				unit.text="";
				sliding.selectedIndex=0;
				prcSliding.selectedIndex=0;
	            break;
	        }
	        case "FIXED_AMOUNT":{
	        	ICharge.includeInLayout = true;
				ICharge.visible = true;
				IAmountLbl.includeInLayout = true;
				IAmountLbl.visible = true;
				IAmountFld.includeInLayout = true;
				IAmountFld.visible = true;
				sliding.selectedIndex=0;
				prcSliding.selectedIndex=0;
	 			min.text="";
	            rate.text="";
	            max.text="";
	            unit.text="";
	            discount.text="";
	            rateType.selectedIndex=0;
	            break;
	        }
	        case "NOM_UNIT":
	        case "LOT_UNIT":
	        case "PRN_UNIT":
	        {
	            sliding.selectedIndex=0;      
	            prcSliding.selectedIndex=0;  
	            IMinMax.includeInLayout = true;
				IMinMax.visible = true;
				ICharge.includeInLayout = true;
				ICharge.visible = true;
				IUnitLbl.includeInLayout = true;
				IUnitLbl.visible = true;
				IUnitFld.includeInLayout = true;
				IUnitFld.visible = true;
				IAmountLbl.includeInLayout = true;
				IAmountLbl.visible = true;
				IAmountFld.includeInLayout = true;
				IAmountFld.visible = true;     
	            rate.text="";
	            discount.text="";
	            rateType.selectedIndex=0;
	            break;
	        }
	        case "SLIDING":{
	            ISliding.includeInLayout = true;
				ISliding.visible = true;
				slidingGen.includeInLayout = true;
				slidingGen.visible = true;
				slidingPrc.includeInLayout = false;
				slidingPrc.visible = false; 
	            rate.text="";
	            min.text="";
	            max.text="";
	            unit.text="";
				amt.text="";
	       		rateType.selectedIndex=0;
	            prcSliding.selectedIndex=0;
	            break;
	        }
	        case "SLIDING_PRICE":{
	            ISliding.includeInLayout = true;
				ISliding.visible = true;
	            rate.text="";
	            min.text="";
	            max.text="";
	            unit.text="";
	            amt.text="";
	            sliding.selectedIndex=0;    
				slidingGen.includeInLayout = false;
				slidingGen.visible = false;
				slidingPrc.includeInLayout = true;
				slidingPrc.visible = true;   
	            rateType.selectedIndex=0;    
	            break;
	   		 }
	        default:{
	            IRate.includeInLayout = false;
				IRate.visible = false;
	            IMinMax.includeInLayout = false;
				IMinMax.visible = false;
	            ICharge.includeInLayout = false;
				ICharge.visible = false;
	            IUnitLbl.includeInLayout = false;
				IUnitLbl.visible = false;
	            IUnitFld.includeInLayout = false;
				IUnitFld.visible = false;
	            IAmountLbl.includeInLayout = false;
				IAmountLbl.visible = false;
	            IAmountFld.includeInLayout = false;
				IAmountFld.visible = false;
	            ISliding.includeInLayout = false;
				ISliding.visible = false;
	            sliding.selectedIndex=0;      
	            prcSliding.selectedIndex=0;      
	            rate.text="";
	            min.text="";
	            max.text="";
	            unit.text="";
	            amt.text="";
	            discount.text="";   
	            slidingGen.includeInLayout=false;
	            slidingGen.visible=false;         
	            rateType.selectedIndex=0;
	            break;
	        }
	    }
	}
	
	// VALIDATE THE Amount FIELD
	private function validateAmount(event:FocusEvent):void
	{
		amtValidator.source = TextInput(event.currentTarget);
		amtValidator.handleNumericField(numberFormatter);
	}
	
	// VALIDATE THE Rate FIELD
	private function validateRate(event:FocusEvent):void
	{
		ratevalidator.source = TextInput(event.currentTarget);
		ratevalidator.handleNumericField(numberFormatter);
	}
	
	// Validate Account Comisson on Addition process
	private function validateOnAddToCommission():Boolean
	{
	    var validationMessage:String = "";
	    var startdate:String =strtDate.text;
	    var enddate:String =endDate.text;
	    var cacMthdVal:String = calcMethod.selectedItem.toString();
	    var securityType:String = this.securityType.itemCombo != null ? this.securityType.itemCombo.text : "" ;
	    if(XenosStringUtils.isBlank(txidComison.selectedItem.value)){
	     	validationMessage+="Commission Id/Name can not be empty.\n"
	     }
	     else if(XenosStringUtils.isBlank(cacMthdVal)){
	     	validationMessage+="Calculation Method can not be empty.\n"
	     }
	     /*
	     else if(XenosStringUtils.isBlank(issrCntry.countryCode.text)){
	     	validationMessage+="Issue Country can not be empty.\n"
	     }
	     */
	     else if(XenosStringUtils.isBlank(securityType)){
	     	validationMessage+="Security Type can not be empty.\n"
	     }
	     /*
	     else if(XenosStringUtils.isBlank(bsFlg.selectedItem.value)){
	     	validationMessage+="Buy/Sell can not be empty.\n"
	     }
	     */
	     else if(XenosStringUtils.isBlank(startdate)){
	     	validationMessage+="Start Date can not be empty.\n"
	     }
	    switch (cacMthdVal)
	    {
	        case "FIXED_RATE":{
		      if(XenosStringUtils.isBlank(rate.text)){
		 		validationMessage+="Rate can not be empty.\n"
		 	   }
		 	   else if(XenosStringUtils.isBlank(rateType.selectedItem.value)){
		 		validationMessage+="Rate Type can not be empty.\n"
		 	   }
		   	 break;
	        }
	        case "FIXED_AMOUNT":{
	             if(XenosStringUtils.isBlank(amt.text)){
		 			validationMessage+="Amount can not be empty.\n"
		 	  	 }
	            break;
	        }
	        case "NOM_UNIT":{
	       		 if(XenosStringUtils.isBlank(amt.text)){
		 			validationMessage+="Amount can not be empty.\n"
		 	  	 }
		 	  	 else if(XenosStringUtils.isBlank(unit.text)){
		 			validationMessage+="Unit can not be empty.\n"
		 	  	 }
	            break;
	        }
	        case "SLIDING":{
	         	if(XenosStringUtils.isBlank(sliding.selectedItem.toString())){
		 			validationMessage+="TableId for Sliding can not be empty.\n"
		 	  	 }
	            break;
	        }
	        case "SLIDING_PRICE":{
	        	if(XenosStringUtils.isBlank(prcSliding.selectedItem.toString())){
		 			validationMessage+="TableId for Sliding Price can not be empty.\n"
		 	  	 }
	            break;
	        }
	    }
	    if(XenosStringUtils.isBlank(startdate)==false && XenosStringUtils.isBlank(enddate)==false)
	    {         
			var dateMatched :int= DateUtils.compareDates (startdate,enddate);
			if(dateMatched == 1){
				validationMessage+="End Date cannot occur before Start Date.\n"
			} 
	    }
	    if ( validationMessage != "")
	    {
	        XenosAlert.error(validationMessage);
	         return false;
	    }
	    return true;
	}
	
	// Called when user clicks on add button
	private function addAccountCommison():void{
		if(validateOnAddToCommission()){
			var req : Object = new Object();
			req.method = "addCommission";
			req.srcTabNo = 6;
			populateRequestparamsActComisson(req);
			addAccountComissonService.request=req;			
			addAccountComissonService.send();
		}
	}
	
	// Called when user clicks on Delete button
	public function deleteAccountCommison(data:Object):void{
		var req : Object = new Object();
		req.method = "deleteCommission";
		req.srcTabNo = 6;
		req.editIndexCommission = acctComissionList.getItemIndex(data); 
		addAccountComissonService.request=req;			
		addAccountComissonService.send();
		
	}
	
	// Called when user clicks on Edit button
	public function editAccountCommison(data:Object):void{
		var req : Object = new Object();
		req.method = "editCommission";
		req.srcTabNo = 6;
		req.editIndexCommission = acctComissionList.getItemIndex(data); 
		addAccountComissonService.request=req;			
		addAccountComissonService.send();
		
	}
	
	// Called when user clicks on Cancel button
	private function cancelComisionChanges():void{
			var req : Object = new Object();
			req.method = "cancelCommission";
			req.srcTabNo = 6;
			addAccountComissonService.request=req;			
			addAccountComissonService.send();
	}
	
	// Called when user clicks on add button
	private function saveUpdatedAccountCommison():void{
		if(validateOnAddToCommission()){
			var req : Object = new Object();
			req.method = "updateCommission";
			req.srcTabNo = 6;
			populateRequestparamsActComisson(req);
			addAccountComissonService.request=req;			
			addAccountComissonService.send();
		}
	}
	
	
	// Populate request parameter on addition
	private function populateRequestparamsActComisson(reqObj : Object):void{
			reqObj['srcTabNo'] = 6;
			reqObj['commissionTax.taxFeeId'] = this.txidComison.selectedItem.value;
			reqObj['commissionTax.taxFeeCalcType'] = this.calcMethod.selectedItem.toString();
			reqObj['commissionTax.issueCountry'] = this.issrCntry.countryCode.text;
			reqObj['commissionTax.instrumentType'] = this.securityType.itemCombo != null ? this.securityType.itemCombo.text : "" ;
			reqObj['commissionTax.buySellFlag'] = this.bsFlg.selectedItem.value;
			reqObj['commissionTax.ruleStartDateStr'] = this.strtDate.text;
			reqObj['commissionTax.ruleEndDateStr'] = this.endDate.text;
			reqObj['commissionTax.chargeRateStr'] = this.rate.text;
			reqObj['commissionTax.rateType'] = this.rateType.selectedItem.value;
			reqObj['commissionTax.defaultMaxStr'] = this.max.text;
			reqObj['commissionTax.defaultMinStr'] = this.min.text;
			reqObj['commissionTax.chargeAmountStr'] = this.amt.text;
			reqObj['commissionTax.chargeUnitStr'] = this.unit.text;
			reqObj['commissionTax.chargeSlidingTableId'] = this.sliding.selectedItem.toString();
			reqObj['commissionTax.chargeSlidingTableIdPrc'] = this.prcSliding.selectedItem.toString();
			reqObj['commissionTax.discountStr'] = this.discount.text
	}



	// Called Result Handler for Add/Delete
	private function addAccountComissionResult(event:ResultEvent):void{
		var addXml:XML = XML(event.result);
		if (addXml!= null) {
			xml=addXml;
	     if(xml.child("Errors").length()>0){
        	convertErrorToArray(xml);
        	if(errList.length>0){
          	  errPage.showError(errList);
        	}
		}else{
			// Initialize Page with values
			initializeAccountComisson(xml);
			errPage.clearError(event);
			}
      }
	}
	
        // Convert the Error into Error Array
   	 private function convertErrorToArray(tempXmlObj:XML):void{
   	 		errList	= new ArrayCollection();
            	trace("In Errors Array");
				for each (var rec:String in tempXmlObj.Errors.error ) {					    	
			 	   errList.addItem(rec);		 				    
			   }
        }
	
	// Fault result Handler for HTTP Request
	private function httpService_fault(evt:FaultEvent):void {
           XenosAlert.error(evt.fault.faultDetail);
    }
	
	
	// Populate Account Commission List Data
	private function populateAcctComissionList(xmlObj:XML):void
	{
		acctComissionList = new ArrayCollection();
		var indx1:int = 0; 
		for each (var rec:Object in xmlObj.otherAttributes.commissionDynaBeansWrapper.item) {		
			   if(xmlObj.editIndexCommission == indx1){
			   	rec.isVisible=false;
			   }else{
			   	rec.isVisible=true;
			   }
		 	   acctComissionList.addItem(rec);	
		 	   indx1++	 				    
		   }
	}
	
	// Method calling to parse Table data == START
	private function displayTaxFeeId(row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='taxFeeId').value;
  	}
  	
  	private function displayTaxFeeCalcType( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='taxFeeCalcType').value;
  	}
  	
  	private function displayIssueCountry( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='issueCountry').value;
  	}
  	
  	private function displayInstrumentType( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='instrumentType').value;
  	}
  	
  	private function displayBuySellFlagExp( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='buySellFlagExp').value;
  	}
  	
  	private function displayChargeRateStr( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='chargeRateStr').value;
  	}
	
	private function displayRateType( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='rateType').value;
  	}
  	
  	private function displayRuleEndDateStr( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='ruleEndDateStr').value;
  	}
  	
  	private function displayRuleStartDateStr( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='ruleStartDateStr').value;
  	}
  	
  	private function displayDefaultMaxStr( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='defaultMaxStr').value;
  	}
  	
  	private function displayDefaultMinStr( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='defaultMinStr').value;
  	}
  	
  	private function displayChargeAmountStr( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='chargeAmountStr').value;
  	}
  	
  	private function displayChargeUnitStr( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='chargeUnitStr').value;
  	}
  	
  	private function displayTableidtaxFeeCalcType( row:Object, column:DataGridColumn ):String {
 		var tableColumn:String = row.entry.(@key=='taxFeeCalcType').value;
 		if(tableColumn == "SLIDING")
 			return row.entry.(@key=='chargeSlidingTableId').value;
 		else if(tableColumn == "SLIDING_PRICE")
 			return row.entry.(@key=='chargeSlidingTableIdPrc').value;
 		else
 			return "";
  	}
  	
  	private function displaydiscountStr( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='discountStr').value;
  	}
 // Method calling to parse Table data == END 	
  	

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