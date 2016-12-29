

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
   

[Bindable]public var xml:XML;
[Bindable]private var taxIdCommissionList:ArrayCollection;
[Bindable]private var calcMethodList:ArrayCollection;
[Bindable]private var rateTypeList:ArrayCollection;
[Bindable]private var slidingList:ArrayCollection;
[Bindable]private var prcSlidingList:ArrayCollection;
[Bindable]private var withholdingTax:ArrayCollection;
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
		setURLModeBind(xml);
		initializeAccountWithHolding(xml);		
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
	private function initializeAccountWithHolding(xmlObj:XML):void{
		// Account No field
		acctNo.text = xmlObj.accountNoExp;
		// Account Name field
		acctName.text = xmlObj.shortNameExp;
		
		//Tax ID/ Name Combo
		taxIdCommissionList = new ArrayCollection();
		taxIdCommissionList.addItem({label: "" , value : ""});
		for each(var xmlTemp:Object in xmlObj.dropDownListValues.taxIdWithholdingTaxList.item){
			taxIdCommissionList.addItem(xmlTemp);
		}
		taxid.selectedIndex = getIndexOfLabelValueBean(taxIdCommissionList, xmlObj.withholdingTax.taxFeeId);
		
		//Calculation Method Combo
		calcMethodList = new ArrayCollection();
		calcMethodList.addItem("");
		for each(var xmlTemp1:Object in xmlObj.dropDownListValues.calculationMethodList.calculationMethod){
			calcMethodList.addItem(xmlTemp1);
		}
		calcMethod.selectedIndex = getIndex(calcMethodList, xmlObj.withholdingTax.taxFeeCalcType);
		
		// Start Date field
		strtDate.text = xmlObj.withholdingTax.ruleStartDateStr; 
		
		// End Date Field
		endDate.text = xmlObj.withholdingTax.ruleEndDateStr; 
		
		// Rate filed
		rate.text = xmlObj.withholdingTax.chargeRateStr; 
		
		// Rate Type Combo Box
		rateTypeList = new ArrayCollection();
		rateTypeList.addItem({label: "" , value : ""});
		for each(var xmlTemp3:Object in xmlObj.dropDownListValues.rateTypeList.item){
			rateTypeList.addItem(xmlTemp3);
		}
		rateType.selectedIndex = getIndexOfLabelValueBean(rateTypeList, xmlObj.withholdingTax.rateType);
		
		// Max Value Field
		max.text = xmlObj.withholdingTax.defaultMaxStr; 
		
		// Min Value Field
		min.text = xmlObj.withholdingTax.defaultMinStr; 
		
		// Amount Value Field
		amt.text = xmlObj.withholdingTax.chargeAmountStr; 
		
		// Unit Value Field
		unit.text = xmlObj.withholdingTax.chargeUnitStr; 
		
		//Tab Field for Sliding Method Combo
		slidingList = new ArrayCollection();
		slidingList.addItem("");
		for each(var xmlTemp4:Object in xmlObj.dropDownListValues.chargeSlidingList.chargeSliding){
			slidingList.addItem(xmlTemp4);
		}
		sliding.selectedIndex = getIndex(slidingList, xmlObj.withholdingTax.chargeSlidingTableId);
		
		//Tab Field for PRC Sliding Method Combo
		prcSlidingList = new ArrayCollection();
		prcSlidingList.addItem("");
		for each(var xmlTemp5:Object in xmlObj.dropDownListValues.chargePrcSlidingList.chargePrcSliding){
			prcSlidingList.addItem(xmlTemp5);
		}
		prcSliding.selectedIndex = getIndex(prcSlidingList, xmlObj.withholdingTax.chargeSlidingTableIdPrc);
		
		// Discount Field
		discount.text = xmlObj.withholdingTax.discountStr; 
		
		// Control the Onchange Flow of the screen
		onChangeCalculationType();
		// Populate Account Commision List Data
		populateWithholdingTaxList(xmlObj);
		// Initialize Edit Index Comisson
		initializeditIndexCommission(xmlObj)
		
	}
	
	// Control The visiblity of Add nd Update button
	private function initializeditIndexCommission(xmlObj:XML):void{
		var editIndex:int=0;
		editIndex= xmlObj.editIndexWithholdingTax;
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
	
	private function onChangeCalculationType():void
	{
	    hideAllCalculationTypeRelatedElements();
	    var calcMethodVal:String = calcMethod.selectedItem.toString();
	    switch (calcMethodVal)
	    {
	        case "FIXED_RATE":{
		       	 IRate.includeInLayout=true;
		         IRate.visible=true;
		         IMinMax.includeInLayout=true;
		         IMinMax.visible=true;
		         sliding.selectedIndex=0;
		         prcSliding.selectedIndex=0;
		         amt.text="";
		         discount.text="";   
		         unit.text="";
				 calcMethod.enabled=false;
				 rateType.enabled=false;
	         break;
	        }
	        case "FIXED_AMOUNT":{
	        	 ICharge.includeInLayout=true;
		         ICharge.visible=true;
		         IAmountLbl.includeInLayout=true;
		         IAmountLbl.visible=true;
		         sliding.selectedIndex=0;
		         prcSliding.selectedIndex=0;
		         rate.text="";
		         min.text="";
		         max.text="";
		         unit.text="";
		         discount.text="";
		         rateType.selectedIndex=0;
	            break;
	        }
	        case "PRN_UNIT":
	        case "LOT_UNIT":
	        case "NOM_UNIT":{
	        	IMinMax.includeInLayout=true;
		        IMinMax.visible=true;
		        ICharge.includeInLayout=true;
		        ICharge.visible=true;
		        IUnitLbl.includeInLayout=true;
		        IUnitLbl.visible=true;
		        IUnitFld.includeInLayout=true;
		        IUnitFld.visible=true;
		        IAmountLbl.includeInLayout=true;
		        IAmountLbl.visible=true;
				sliding.selectedIndex=0;
		        prcSliding.selectedIndex=0;       
	            rate.text="";
	            discount.text="";
	            rateType.selectedIndex=0;
	            break;
	        }
	        case "SLIDING":{
	        	ISliding.includeInLayout=true;
		        ISliding.visible=true;
		        slidingGen.includeInLayout=true;
		        slidingGen.visible=true;
		        slidingPrc.includeInLayout=false;
		        slidingPrc.visible=false;
	            rate.text="";
	            min.text="";
		        max.text="";
		        unit.text="";
		        amt.text="";
	            rateType.selectedIndex=0;
	            break;
	        }
	        case "SLIDING_PRICE":{
	        	ISliding.includeInLayout=true;
		        ISliding.visible=true;
		        slidingGen.includeInLayout=false;
		        slidingGen.visible=false;
		        slidingPrc.includeInLayout=true;
		        slidingPrc.visible=true;
	            
	            rate.text="";
	            min.text="";
		        max.text="";
		        unit.text="";
		        amt.text="";
	            rateType.selectedIndex=0;
	            break;
	        }
	        default:{
	        	IRate.includeInLayout=false;
		        IRate.visible=false;
		        IMinMax.includeInLayout=false;
		        IMinMax.visible=false;
		        ICharge.includeInLayout=false;
		        ICharge.visible=false;
		        IUnitLbl.includeInLayout=false;
		        IUnitLbl.visible=false;
		        IUnitFld.includeInLayout=false;
		        IUnitFld.visible=false;
		        IAmountLbl.includeInLayout=false;
		        IAmountLbl.visible=false;
		        ISliding.includeInLayout=false;
		        ISliding.visible=false;
				sliding.selectedIndex=0;
		        prcSliding.selectedIndex=0;       
	            rate.text="";
	            min.text="";
		        max.text="";
		        unit.text="";
		        amt.text="";
	            discount.text="";
	            rateType.selectedIndex=0;
	            break;
	        }
	    }
	}
	
	private	function hideAllCalculationTypeRelatedElements():void
	{
		IRate.includeInLayout=false;
		IRate.visible=false;
		IMinMax.includeInLayout=false;
		IMinMax.visible=false;
		ICharge.includeInLayout=false;
		ICharge.visible=false;
		IUnitLbl.includeInLayout=false;
		IUnitLbl.visible=false;
		IUnitFld.includeInLayout=false;
		IUnitFld.visible=false;
		IAmountLbl.includeInLayout=false;
		IAmountLbl.visible=false;
		ISliding.includeInLayout=false;
		ISliding.visible=false;		
	   
	}
	
	private function validateOnAddToWithHoldingTax():Boolean
	{
	 	var validationMessage:String = "";
	    var startdate:String =strtDate.text;
	    var enddate:String =endDate.text;
	    var cacMthdVal:String = calcMethod.selectedItem.toString();
	    
	    if(XenosStringUtils.isBlank(taxid.selectedItem.value)){
	     	validationMessage+="Tax ID/Name can not be empty\n"
	     }
	     if(XenosStringUtils.isBlank(cacMthdVal)){
	     	validationMessage+="Calculation Method can not be empty\n"
	     }
	     if(XenosStringUtils.isBlank(startdate)){
	     	validationMessage+="Start Date can not be empty\n"
	     }else if(!DateUtils.isValidDate(startdate)){
	     	 validationMessage+="Invalid Rule Start Date specified\n"
	     }
	     if(!XenosStringUtils.isBlank(enddate) && !DateUtils.isValidDate(enddate)){
	     	 validationMessage+="Invalid Rule End Date specified\n"
	     }
	
	    switch (cacMthdVal)
	    {
	        case "FIXED_RATE":{
	            if(XenosStringUtils.isBlank(rate.text)){
		 		validationMessage+="Rate can not be empty\n"
		 	   }
		 	   if(XenosStringUtils.isBlank(rateType.selectedItem.value)){
		 		validationMessage+="Rate Type can not be empty\n"
		 	   }
	            break;
	        }
	        case "FIXED_AMOUNT":{
	        	if(XenosStringUtils.isBlank(amt.text)){
		 			validationMessage+="Amount can not be empty\n"
		 	  	 }
	            break;
	        }
	        case "PRN_UNIT":
	        case "LOT_UNIT":
	        case "NOM_UNIT":{
	           if(XenosStringUtils.isBlank(amt.text)){
		 			validationMessage+="Amount can not be empty\n"
		 	  	 }
		 	  	 if(XenosStringUtils.isBlank(unit.text)){
		 			validationMessage+="Unit can not be empty\n"
		 	  	 }
	            break;
	   	   }
	       case "SLIDING":{
	         	if(XenosStringUtils.isBlank(sliding.selectedItem.toString())){
		 			validationMessage+="TableId for Sliding can not be empty\n"
		 	  	 }
	            break;
	        }
	       case "SLIDING_PRICE":{
	        	if(XenosStringUtils.isBlank(prcSliding.selectedItem.toString())){
		 			validationMessage+="TableId for Sliding Price can not be empty\n"
		 	  	 }
	            break;
	       }
	    }
//	     if(XenosStringUtils.isBlank(startdate)==false && XenosStringUtils.isBlank(enddate)==false)
//	    {         
//			var dateMatched :int= DateUtils.compareDates (startdate,enddate);
//			if(dateMatched == 1){
//				validationMessage+="End Date cannot occur before Start Date."
//			} 
//	    }
	
	    if ( validationMessage != "")
	    {
	        XenosAlert.error(validationMessage);
	         return false;
	    }
	    return true;
	}
	
	// Populate Account Commission List Data
	private function populateWithholdingTaxList(xmlObj:XML):void
	{
		withholdingTax = new ArrayCollection();
		var indx1:int = 0; 
		for each (var rec:Object in xmlObj.otherAttributes.withholdingTaxDynaBeansWrapper.item) {		
			   if(xmlObj.editIndexWithholdingTax == indx1){
			   	rec.isVisible=false;
			   }else{
			   	rec.isVisible=true;
			   }
		 	 withholdingTax.addItem(rec);	
	 	  	 indx1++	 				    
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
	
	// Method calling to parse Table data == START
	private function displayTaxFeeId(row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='taxFeeId').value;
  	}
  	private function displayTaxFeeCalcType( row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='taxFeeCalcType').value;
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
	
	// Called when user clicks on add button
	private function addWithholdingTax():void{
		if(validateOnAddToWithHoldingTax()){
			var req : Object = new Object();
			req.method = "addWithholdingTax";
			req.srcTabNo = 8;
			populateRequestparams(req);
			addAccountWithHolding.request=req;			
			addAccountWithHolding.send();
		}
	}
	
	// Called when user clicks on Delete button
	public function deleteWithholdingTax(data:Object):void{
		var req : Object = new Object();
		req.method = "deleteWithholdingTax";
		req.srcTabNo = 8;
		req.editIndexWithholdingTax = withholdingTax.getItemIndex(data); 
		addAccountWithHolding.request=req;			
		addAccountWithHolding.send();
		
	}
	
	// Called when user clicks on Edit button
	public function editWithholdingTax(data:Object):void{
		var req : Object = new Object();
		req.method = "editWithholdingTax";
		req.srcTabNo = 8;
		req.editIndexWithholdingTax = withholdingTax.getItemIndex(data); 
		addAccountWithHolding.request=req;			
		addAccountWithHolding.send();
		
	}
	
	// Called when user clicks on Cancel button
	private function cancelWithholdingTax():void{
		var req : Object = new Object();
		req.method = "cancelWithholdingTax";
		req.srcTabNo = 8;
		addAccountWithHolding.request=req;			
		addAccountWithHolding.send();
	}
	
	// Called when user clicks on add button
	private function updateWithholdingTax():void{
		if(validateOnAddToWithHoldingTax()){
			var req : Object = new Object();
			req.method = "updateWithholdingTax";
			req.srcTabNo = 8;
			populateRequestparams(req);
			addAccountWithHolding.request=req;			
			addAccountWithHolding.send();
		}
	}
	
	// Populate request parameter on addition/ Updation
	private function populateRequestparams(reqObj : Object):void{
			reqObj['srcTabNo'] = 8;
			reqObj['withholdingTax.taxFeeId'] = this.taxid.selectedItem.value;
			reqObj['withholdingTax.taxFeeCalcType'] = this.calcMethod.selectedItem.toString();
			reqObj['withholdingTax.ruleStartDateStr'] = this.strtDate.text;
			reqObj['withholdingTax.ruleEndDateStr'] = this.endDate.text;
			reqObj['withholdingTax.chargeRateStr'] = this.rate.text;
			reqObj['withholdingTax.rateType'] = this.rateType.selectedItem.value;
			reqObj['withholdingTax.defaultMaxStr'] = this.max.text;
			reqObj['withholdingTax.defaultMinStr'] = this.min.text;
			reqObj['withholdingTax.chargeAmountStr'] = this.amt.text;
			reqObj['withholdingTax.chargeUnitStr'] = this.unit.text;
			reqObj['withholdingTax.chargeSlidingTableId'] = this.sliding.selectedItem.toString();
			reqObj['withholdingTax.chargeSlidingTableIdPrc'] = this.prcSliding.selectedItem.toString();
			reqObj['withholdingTax.discountStr'] = this.discount.text
	}
	
	// Called Result Handler for Add/Delete
	private function addAccountWithHoldingResult(event:ResultEvent):void{
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
			initializeAccountWithHolding(xml);
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