

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
   

[Bindable]public var xml:XML;
[Bindable]private var restrictionIdList:ArrayCollection;
[Bindable]private var restrictionStatusList:ArrayCollection;
[Bindable]private var editResMode:Boolean = false;
[Bindable]private var restrictionSummaryResult:ArrayCollection = new ArrayCollection();
private var srcTabNo:int = 7;
[Bindable]private var urlModeBind:String="Entry";

private static var CP_INTERNAL:String="INTERNAL";
private static var CP_BANKCUST:String="BANK/CUSTODIAN";
private static var CP_BROKER:String="BROKER";

override public function populateRequest():Object{
	var reqObj:Object = new Object();
	reqObj['srcTabNo'] = srcTabNo;
	reqObj['restrictionRolePage.restrictionId']  = this.restrictionId.selectedItem != null ? this.restrictionId.selectedItem.toString() : "";;
	reqObj['restrictionRolePage.restrictionFlag'] = this.restrictionFlag.selectedItem != null ? this.restrictionFlag.selectedItem.value : "";;
	reqObj['restrictionRolePage.startDateStr'] = this.startDateStr.text;
	reqObj['restrictionRolePage.endDateStr'] = this.endDateStr.text;
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
	initializeAccountRestriction(xml);
}

private function initializeAccountRestriction(xmlObj:XML):void{
	var xmlObj1:Object = new Object();
	var xmlObj2:Object = new Object();
	//populate Restriction List
	
	restrictionIdList = new ArrayCollection();
	restrictionIdList.addItem(" ");
	for each(xmlObj1 in xmlObj.dropDownListValues.restrictionIdList.restrictionId){
		restrictionIdList.addItem(xmlObj1);
	}
	restrictionId.selectedIndex = getIndex(restrictionIdList, xmlObj.restrictionRolePage.restrictionId);
	
	//populate Restriction List
	
	restrictionStatusList = new ArrayCollection();
	restrictionStatusList.addItem({label:" ", value:" "});
	for each(xmlObj2 in xmlObj.dropDownListValues.restrictionStatusList.item){
		restrictionStatusList.addItem(xmlObj2);
	}
	restrictionFlag.selectedIndex = getIndexOfLabelValueBean(restrictionStatusList, xmlObj.restrictionRolePage.restrictionFlag);
	
	startDateStr.text = xmlObj.restrictionRolePage.startDateStr;
	endDateStr.text = xmlObj.restrictionRolePage.endDateStr;
	
	// Initialize Edit Index Restriction
	initializeditIndexRestriction(xmlObj);
	
	if(this.mode=="amend" || this.mode=="copy"){
		var indx1:int = 0;				
        restrictionSummaryResult.removeAll(); 
            	
		 for each ( var rec:XML in xmlObj.otherAttributes.accountRestrictionDynaBeansWrapper.item) {
				if(xmlObj.editIndexRestriction == indx1){
					 rec.isVisible=false;
				}else{
					  rec.isVisible=true;
				}

 				restrictionSummaryResult.addItem(rec);
 				indx1++;
		 }
			   			  
            restrictionSummaryResult.refresh();
            restrictionSummary.visible = true;
            restrictionSummary.includeInLayout = true;
			
		  
	}
}
// Control The visiblity of Add nd Update button
	private function initializeditIndexRestriction(xmlObj:XML):void{
		var editIndex:int=0;
		editIndex= xmlObj.editIndexRestriction;
		if(editIndex==-1){
			editResMode = false;
		}else{
			editResMode = true;
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

/**
 * This method will be called for basic validations for the Add button of Restriction Info in the Restriction Tab.
 * The following variables will be validated in this method :
 * Restriction ID/Name
 * Restriction Status
 */
private function validateOnAddToRestriction():Boolean
{
    var errorStr:String = "";
    var validDate1:Boolean = false;
 	var validDate2:Boolean = false;
 	var compareResult:Number = 1;
 	var errorFlag:Boolean = false;
 			
    if(XenosStringUtils.isBlank(this.restrictionId.selectedItem.toString())){
		errorFlag = true;
		errorStr += "Restriction ID/Name can not be empty.\n";
	}
	if(XenosStringUtils.isBlank(this.restrictionFlag.selectedItem.value)){
		errorFlag = true;
		errorStr += "Restriction Status can not be empty.\n";
	}
	if(XenosStringUtils.isBlank(this.startDateStr.text)){
		errorFlag = true;
		errorStr += "Start Date can not be empty.\n";
	}else{
		validDate1 = DateUtils.isValidDate(StringUtil.trim(this.startDateStr.text)) ; 
		if(!validDate1) {
	           errorFlag = true;
			   errorStr += "Illegal Start date format.\n"; 
	               
	    }else{
			if(!XenosStringUtils.isBlank(this.endDateStr.text)){
				validDate2 = DateUtils.isValidDate(StringUtil.trim(this.endDateStr.text)); 
				if(!validDate2) {
	           		errorFlag = true;
			   		errorStr += "Illegal End date format.\n"; 
	               
	   			}else if(validDate1 && validDate2){
	        		compareResult = DateUtils.compareDates (this.startDateStr.text, this.endDateStr.text);
	        		if(compareResult == 1){
	        			errorFlag = true;
						errorStr += "End Date cannot occur before Start Date.\n";
	        		}
	        	}
				 
			}
	    }
	}
	if(errorFlag){
		XenosAlert.error(errorStr);
		return false;
	}
	return true;

}
 
 
/**
 * To add Restriction Information
 */
private function addRestriction():void{
	var errorFlag:Boolean = false;
	errorFlag = validateOnAddToRestriction();
	if(errorFlag){
		addRestrictionService.request = populateRestriction();
//		addRestrictionService.url = "ref/accountDispatch.action?method=addRestrictionXref"
		addRestrictionService.send();
	}
}

/**
 * To edit Restriction Information
 */        
public function editRestriction(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.editIndexRestriction = restrictionSummaryResult.getItemIndex(data);
	
	for each(var obj:Object in restrictionSummaryResult){
		obj.isVisible=true;
			
	}
	
	reqObj.srcTabNo = srcTabNo;
	data.isVisible=false;
	restrictionSummaryResult.refresh();
//	editRestrictionService.url = "ref/accountDispatch.action?method=editRestrictionXref"
	editRestrictionService.request = reqObj;
	editRestrictionService.send();
}

/**
 * To delete Restriction Information
 */         
public function deleteRestriction(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.editIndexRestriction = restrictionSummaryResult.getItemIndex(data);
	reqObj.srcTabNo = srcTabNo;
//	deleteRestrictionService.url = "ref/accountDispatch.action?method=deleteRestrictionXref"
	deleteRestrictionService.request = reqObj;
	deleteRestrictionService.send();
}      

/**
 * To save Restriction Information
 */         
public function saveRestriction():void{
	var errorFlag:Boolean = false;
	errorFlag = validateOnAddToRestriction();
	if(errorFlag){
//		saveRestrictionService.url = "ref/accountDispatch.action?method=updateRestrictionXref"
		saveRestrictionService.request = populateEditedRestriction();
		saveRestrictionService.send();
	}
}

/**
 * To cancel the edited Restriction Information
 */         
private function cancelEditRestriction():void{
	
//	cancelEditRestrictionService.url = "ref/accountDispatch.action?method=cancelRestrictionXref"
	cancelEditRestrictionService.request = populateEditedRestriction();
	cancelEditRestrictionService.send();
}

/**
 * Bind the Restriction info to the request object
 */         
private function populateEditedRestriction():Object{
	var reqObj : Object = new Object();
	reqObj['restrictionRolePage.restrictionId']  = this.restrictionId.selectedItem != null ? this.restrictionId.selectedItem.toString() : "";
	reqObj['restrictionRolePage.restrictionFlag'] = this.restrictionFlag.selectedItem != null ? this.restrictionFlag.selectedItem.value : "";
	reqObj['restrictionRolePage.startDateStr'] = this.startDateStr.text;
	reqObj['restrictionRolePage.endDateStr'] = this.endDateStr.text;
	reqObj.srcTabNo = srcTabNo;
	return reqObj;
}

private function populateRestriction():Object{
	var reqObj : Object = new Object();
	reqObj['restrictionRolePage.restrictionId']  = this.restrictionId.selectedItem != null ? this.restrictionId.selectedItem.toString() : "";
	reqObj['restrictionRolePage.restrictionFlag'] = this.restrictionFlag.selectedItem != null ? this.restrictionFlag.selectedItem.value : "";
	reqObj['restrictionRolePage.startDateStr'] = this.startDateStr.text;
	reqObj['restrictionRolePage.endDateStr'] = this.endDateStr.text;
	reqObj.srcTabNo = srcTabNo;
	return reqObj;
}

/**
* This method works as the result handler of the Submit Query Http Services.
* 
*/
public function restrictionResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);
    var indx1:int = 0; 
  
	if (null != event) {
		 if(rs.child("otherAttributes").length()>0) {
			errPage.clearError(event);
				
            	restrictionSummaryResult.removeAll(); 
            	 // Initialize Page with values
				initializeAccountRestriction(rs);
			
			try {
			    if(this.mode !="amend" && this.mode !="copy"){
				    for each ( var rec:XML in rs.otherAttributes.accountRestrictionDynaBeansWrapper.item) {
				    	if(rs.editIndexRestriction == indx1){
						   	rec.isVisible=false;
						   }else{
						   	rec.isVisible=true;
						   }
	
	 				    restrictionSummaryResult.addItem(rec);
	 				    indx1++;
				    }
			   
			  
            		restrictionSummaryResult.refresh();
            		restrictionSummary.visible = true;
            		restrictionSummary.includeInLayout = true;
      			 }
			}catch(e:Error){
			    XenosAlert.error(e.message);//e.toString() +
			   // XenosAlert.error("No result found");
		    }
		  
		 } 
		 else if(rs.child("Errors").length()>0) {
            //some error found
		 	// clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
		 	errPage.clearError(event);
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } 
		 else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	restrictionSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

// Method calling to parse Table data == START
	private function getRestrictionId(row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='restrictionId').value;
  	}
  	
  	private function getRestrictionFlagExp(row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='restrictionFlagExp').value;
  	}
  	
  	private function getStartDateStr(row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='startDateStr').value;
  	}
  	
  	private function getEndDateStr(row:Object, column:DataGridColumn ):String {
 		return row.entry.(@key=='endDateStr').value;
  	}
