


import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.swp.validator.TradeDeliverReceiveEntryValidator;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]public var xml:XML;
[Bindable]public var businessCenterList:ArrayCollection = new ArrayCollection();
[Bindable]public var paymentScheduleList:ArrayCollection = new ArrayCollection();

[Bindable]public var delFixedfFoatingTypeList:ArrayCollection = new ArrayCollection();
[Bindable]public var delIntRateTypeList:ArrayCollection = new ArrayCollection();
[Bindable]public var delAccruedCalBasisList:ArrayCollection = new ArrayCollection();
[Bindable]public var delAccruedAdjustmentList:ArrayCollection = new ArrayCollection();
[Bindable]public var delPaymentAdjustmentTypeList:ArrayCollection = new ArrayCollection();
[Bindable]public var delPaymentFreqList:ArrayCollection = new ArrayCollection();
[Bindable]public var delRoundingPolicyList:ArrayCollection = new ArrayCollection();
[Bindable]public var delBasisList:ArrayCollection = new ArrayCollection();
[Bindable]public var delPaymentMonthList:ArrayCollection = new ArrayCollection();
[Bindable]public var delPaymentDayList:ArrayCollection = new ArrayCollection();

[Bindable]public var editBusCenterMode:Boolean = false;
[Bindable]public var editPaymentScheduleMode:Boolean = false;
[Bindable]private var editBusCntrIndex:int = -1;
[Bindable]private var editPmntSchdlIndex:int = -1;

private var editFlag:Boolean = false;
private var editPSFlag:Boolean = false;

[Bindable] private var terminationMode : Boolean = false ;

override public function initPage(response:XML):void {
	var obj:Object=new Object();
	xml = response as XML;
	
	if (XenosStringUtils.equals(xml.modeOfOperation , "TERMINATION")) {
		terminationMode = true ;
	}
		
	delNotionalAmt.text = xml.deliverySideDetail.streamDetail.notionalAmountStr;
    
    delFixedfFoatingTypeList.removeAll();
    delFixedfFoatingTypeList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.fixedFloatingTypeList.item){
        delFixedfFoatingTypeList.addItem(obj);
    }
    delFixedfFoatingType.selectedIndex = getIndexOfLabelValueBean(delFixedfFoatingTypeList, xml.deliverySideDetail.streamDetail.fixedFloatingType);
    checkRateType();
    
    delFixedIntRate.text = xml.deliverySideDetail.streamDetail.fixedInterestRateVal;
    
    delIntRateTypeList.removeAll();
    delIntRateTypeList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.interestRateType.item){
        delIntRateTypeList.addItem(obj);
    }
    delIntRateType.selectedIndex = getIndexOfLabelValueBean(delIntRateTypeList, xml.deliverySideDetail.streamDetail.interestRateTypes);
    
    delOffsetFloatingIntRate.text =  xml.deliverySideDetail.streamDetail.spreadVal;
    delResetDateOffset.text = xml.deliverySideDetail.streamDetail.resetDateOffsetStr;
    
    delAccruedCalBasisList.removeAll();
    delAccruedCalBasisList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.accrualBasisList.item){
        delAccruedCalBasisList.addItem(obj);
    }
    delAccruedCalBasis.selectedIndex = getIndexOfLabelValueBean(delAccruedCalBasisList, xml.deliverySideDetail.streamDetail.dayCountFractionBasis);
    
    delAccruedAdjustmentList.removeAll();
    delAccruedAdjustmentList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.accrualAdjustmentFlagList.item){
        delAccruedAdjustmentList.addItem(obj);
    }
    delAccruedAdjustment.selectedIndex = getIndexOfLabelValueBean(delAccruedAdjustmentList, xml.deliverySideDetail.streamDetail.accruedAdjustmentFlag);
    
    delPaymentAdjustmentTypeList.removeAll();
    delPaymentAdjustmentTypeList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.dayConventionList.item){
        delPaymentAdjustmentTypeList.addItem(obj);
    }
    delPaymentAdjustmentType.selectedIndex = getIndexOfLabelValueBean(delPaymentAdjustmentTypeList, xml.deliverySideDetail.streamDetail.dayConvention);
    
    delPaymentFreqList.removeAll();
    delPaymentFreqList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.paymentFrequencyList.item){
        delPaymentFreqList.addItem(obj);
    }
    delPaymentFreq.selectedIndex = getIndexOfLabelValueBean(delPaymentFreqList, xml.deliverySideDetail.streamDetail.paymentFrequency);
    
    delPaymentCcy.ccyText.text = xml.deliverySideDetail.streamDetail.paymentCcyStr;
    
    delFirstPaymentDate.text = xml.deliverySideDetail.streamDetail.firstValueDateStr;
    
	delLastRegularPaymentDate.text = xml.deliverySideDetail.streamDetail.lastRegularValueDateStr;
    
    delRoundingPolicyList.removeAll();
    delRoundingPolicyList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.roundingPolicyList.item){
        delRoundingPolicyList.addItem(obj);
    }
    delRoundingPolicy.selectedIndex = getIndexOfLabelValueBean(delRoundingPolicyList, xml.deliverySideDetail.streamDetail.roundingPolicy);
    
	//Business center fields population
    delMarketTree.itemCombo.text = xml.deliverySideDetail.businessCenterDetail.finInstCode;
    
    delBasisList.removeAll();
    delBasisList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.businessCenterBasisList.item){
        delBasisList.addItem(obj);
    }
    delBasis.selectedIndex = getIndexOfLabelValueBean(delBasisList, xml.deliverySideDetail.businessCenterDetail.basis);
    //Business center results population
    businessCenterList.removeAll();
	for each(obj in xml.deliverySideDetail.businessCenterList.businessCenter){
        businessCenterList.addItem(obj);
    }
    //Payment schedule fields population
    delPaymentMonthList.removeAll();
    delPaymentMonthList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.paymentMonthList.item){
        delPaymentMonthList.addItem(obj);
    }
    delPaymentMonth.selectedIndex = getIndexOfLabelValueBean(delPaymentMonthList, xml.deliverySideDetail.paymentScheduleDetail.paymentMonthStr);
    
    delPaymentDayList.removeAll();
    delPaymentDayList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.paymentDayList.item){
        delPaymentDayList.addItem(obj);
    }
    delPaymentDay.selectedIndex = getIndexOfLabelValueBean(delPaymentDayList, xml.deliverySideDetail.paymentScheduleDetail.paymentDay);
	//Payment schedule results population
	paymentScheduleList.removeAll();
    for each(obj in xml.deliverySideDetail.paymentScheduleList.paymentSchedule){
        paymentScheduleList.addItem(obj);
    }
}
/**
 * validate delivery tab
 */
override public function  validate():ValidationResultEvent {		
    var validator:TradeDeliverReceiveEntryValidator = new TradeDeliverReceiveEntryValidator();
    var model:Object = populateRequest();
    return validator.validate(model);        	
}
/**
 * populate delivery tab
 */
override public function populateRequest():Object {
	
	var reqObj:Object = new Object();
	reqObj.srcTabNo = "2";
    
    reqObj['SCREEN_KEY'] 					  							= 12032;//need to change during amend
    //reqObj['deliverySideStreamObj.streamObj.accrualBasis']				= StringUtil.trim(this.delAccruedCalBasis.selectedItem != null? this.delAccruedCalBasis.selectedItem.value: "");
    reqObj['deliverySideStreamObj.streamObj.dayCountFractionBasis']		= StringUtil.trim(this.delAccruedCalBasis.selectedItem != null? this.delAccruedCalBasis.selectedItem.value: "");
    reqObj['deliverySideStreamObj.streamObj.accruedAdjustmentFlag']		= StringUtil.trim(this.delAccruedAdjustment.selectedItem != null? this.delAccruedAdjustment.selectedItem.value: "");
    reqObj['deliverySideStreamObj.streamObj.dayConvention']				= StringUtil.trim(this.delPaymentAdjustmentType.selectedItem != null? this.delPaymentAdjustmentType.selectedItem.value: "");
    reqObj['deliverySideStreamObj.streamObj.firstValueDateStr']			= StringUtil.trim(delFirstPaymentDate.text);
    reqObj['deliverySideStreamObj.streamObj.lastRegularValueDateStr']   = StringUtil.trim(delLastRegularPaymentDate.text);
    /* var amount:String = StringUtil.trim(delNotionalAmt.text);
    amount = amount.replace(/\,/g, ''); */
    reqObj['deliverySideStreamObj.streamObj.notionalAmountStr']			= StringUtil.trim(delNotionalAmt.text);
    reqObj['deliverySideStreamObj.streamObj.paymentCcyStr']				= StringUtil.trim(delPaymentCcy.ccyText.text);
    reqObj['deliverySideStreamObj.streamObj.paymentFrequency']		    = StringUtil.trim(this.delPaymentFreq.selectedItem != null? this.delPaymentFreq.selectedItem.value: "");
    reqObj['deliverySideStreamObj.streamObj.roundingPolicy']			= StringUtil.trim(this.delRoundingPolicy.selectedItem != null? this.delRoundingPolicy.selectedItem.value: "");

	var fixedFloatingType:String = StringUtil.trim(this.delFixedfFoatingType.selectedItem != null? this.delFixedfFoatingType.selectedItem.value: ""); 
    reqObj['deliverySideStreamObj.streamObj.fixedFloatingType']        	= fixedFloatingType;
    if(XenosStringUtils.equals(fixedFloatingType,Globals.FIXED_TYPE)){
    	reqObj['deliverySideStreamObj.streamObj.fixedInterestRateVal']		= StringUtil.trim(delFixedIntRate.text);    
    	reqObj['deliverySideStreamObj.streamObj.interestRateTypes']			= "";
    	reqObj['deliverySideStreamObj.streamObj.spreadVal']					= "";
    	reqObj['deliverySideStreamObj.streamObj.resetDateOffsetStr']		= "";
    }else if(XenosStringUtils.equals(fixedFloatingType,Globals.FLOATING_TYPE)){
    	reqObj['deliverySideStreamObj.streamObj.fixedInterestRateVal']		= "";    
    	reqObj['deliverySideStreamObj.streamObj.interestRateTypes']			= StringUtil.trim(this.delIntRateType.selectedItem != null? this.delIntRateType.selectedItem.value: "");
    	reqObj['deliverySideStreamObj.streamObj.spreadVal']					= StringUtil.trim(delOffsetFloatingIntRate.text);
    	reqObj['deliverySideStreamObj.streamObj.resetDateOffsetStr']		= StringUtil.trim(delResetDateOffset.text);
    }else {
    	reqObj['deliverySideStreamObj.streamObj.fixedInterestRateVal']		= "";    
    	reqObj['deliverySideStreamObj.streamObj.interestRateTypes']			= "";
    	reqObj['deliverySideStreamObj.streamObj.spreadVal']					= "";
    	reqObj['deliverySideStreamObj.streamObj.resetDateOffsetStr']		= "";
    }
    
    reqObj['businessCenterLength'] = businessCenterList.length;
    reqObj['paymentScheduleLength'] = paymentScheduleList.length;
    reqObj['vdBasisPresent'] = vdBasisCheck();
	
	return reqObj;
}
/**
 * Checks if atleast one VALUE_DATE basis is present or not
 */
private function vdBasisCheck():Boolean {
	var vdBasisPresent:Boolean = false;
	for( var i:int = 0; i < businessCenterList.length; i++ ) {
		var busCenter:Object = businessCenterList[i] as Object;
		if(busCenter.hasOwnProperty("basis")){
			var basis:String = busCenter.basis;
			if(XenosStringUtils.equals(basis,Globals.VALUE_DATE_BASIS)){
				vdBasisPresent = true;
			}
		}
	}
	return vdBasisPresent;
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
 * Check the rate type (Fixed / Floating) and based on that show 
 * or hide screen attribute(s) 
 * */
private function checkRateType():void {
	var selVal:String = delFixedfFoatingType.selectedItem.value;
	
	if(XenosStringUtils.equals(selVal,Globals.FIXED_TYPE)) {	
		delFixedIntRate.visible = true;
		delFixedIntRate.includeInLayout = true;
		delFixedIntRateLabel.visible = true;
		delFixedIntRateLabel.includeInLayout = true;
		
		delIntRateType.visible = false;
		delIntRateType.includeInLayout = false;				
		delIntRateTypeLabel.visible = false;
		delIntRateTypeLabel.includeInLayout = false;
		
		delFloatingRow.visible = false;
		delFloatingRow.includeInLayout = false;
		
		delIntRateType.selectedIndex = 0;
		delOffsetFloatingIntRate.text = "";
		delResetDateOffset.text = "";							
	} else if(XenosStringUtils.equals(selVal,Globals.FLOATING_TYPE)) {
		delFixedIntRate.visible = false;
		delFixedIntRate.includeInLayout = false;
		delFixedIntRateLabel.visible = false;
		delFixedIntRateLabel.includeInLayout = false;
        
		delIntRateType.visible = true;
		delIntRateType.includeInLayout = true;				
		delIntRateTypeLabel.visible = true;
		delIntRateTypeLabel.includeInLayout = true;
        
        delFloatingRow.visible = true;
		delFloatingRow.includeInLayout = true;
		
		delFixedIntRate.text = "";
	} else {
		delFixedIntRate.visible = false;
		delFixedIntRate.includeInLayout = false;
		delFixedIntRateLabel.visible = false;
		delFixedIntRateLabel.includeInLayout = false;
        
        delIntRateType.visible = false;
		delIntRateType.includeInLayout = false;				
		delIntRateTypeLabel.visible = false;
		delIntRateTypeLabel.includeInLayout = false;
        
        delFloatingRow.visible = false;
		delFloatingRow.includeInLayout = false;
		
		delIntRateType.selectedIndex = 0;
		delOffsetFloatingIntRate.text = "";
		delResetDateOffset.text = "";
		delFixedIntRate.text = "";
	} 
}

/**
 * To add BusinessCenter Information
 */
private function addBusinessCenter():void {
	if(validateBusinesscenter()){
		return;
	}
	editFlag = false;
	var reqObj:Object = populateBusinessCenterRequest();
	addBusinessCenterService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=addBusinessCenter";
	} else if (XenosStringUtils.equals(mode , "amend")
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=addBusinessCenter";
	}
	addBusinessCenterService.url = url;
	addBusinessCenterService.send();
}
/**
 * To cancel BusinessCenter Information
 */
private function cancelBusinessCenter():void {
	var reqObj : Object = new Object();
	editFlag = false;
	reqObj.srcTabNo = "2";
	reqObj.editIndexBusinessCenter = editBusCntrIndex;
	addBusinessCenterService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=cancelBusinessCenter";
	} else if (XenosStringUtils.equals(mode , "amend")
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=cancelBusinessCenter";
	}
	addBusinessCenterService.url = url ;
	addBusinessCenterService.send();
}
/**
 * To save BusinessCenter Information
 */
private function saveBusinessCenter():void {
	if(validateBusinesscenter()){
		return;
	}
	editFlag = false;
	var reqObj:Object = populateBusinessCenterRequest();
	reqObj.editIndexBusinessCenter = editBusCntrIndex;
	addBusinessCenterService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=saveBusinessCenter";
	} else if (XenosStringUtils.equals(mode , "amend")
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=saveBusinessCenter";
	}
	addBusinessCenterService.url = url ;
	addBusinessCenterService.send();
}
/**
 * To edit Business Center Information
 */        
public function editBusinessCenter(data:Object):void {
	var reqObj : Object = new Object();
	
	editFlag = true;
	editBusCntrIndex = businessCenterList.getItemIndex(data);
	reqObj.editIndexBusinessCenter = editBusCntrIndex;
	reqObj.srcTabNo = "2";
	
	addBusinessCenterService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=editBusinessCenter";
	} else if (XenosStringUtils.equals(mode , "amend") 
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=editBusinessCenter";
	}
	addBusinessCenterService.url = url ;
	addBusinessCenterService.send();
}
/**
 * To delete Business Center Information
 */        
public function deleteBusinessCenter(data:Object):void {
	var reqObj : Object = new Object();
	editFlag = false;
	editBusCntrIndex = businessCenterList.getItemIndex(data);
	reqObj.editIndexBusinessCenter = editBusCntrIndex;
	reqObj.srcTabNo = "2";
	
	addBusinessCenterService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=deleteBusinessCenter";
	} else if (XenosStringUtils.equals(mode , "amend") 
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=deleteBusinessCenter";
	}
	addBusinessCenterService.url = url ;
	addBusinessCenterService.send();
}
/**
* This method works as the result handler of the business center.
*/
public function addBusinessCenterResult(event:ResultEvent):void {

	if(event != null){
		if(event.result != null){
			if(event.result.hasOwnProperty("XenosErrors") &&
			   event.result.XenosErrors != null){
				if(event.result.XenosErrors.Errors != null){
					if(event.result.XenosErrors.Errors.error != null){
						errPage.removeError();
						var errorInfoList : ArrayCollection = new ArrayCollection();
						if(event.result.XenosErrors.Errors.error is ArrayCollection){
	    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
	    				}else{
	    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
	    				}
	    				errPage.showError(errorInfoList);
					}
				}
			}else {
				var resultObj:Object = event.result.swpEntryActionForm;
				errPage.clearError(event);
				businessCenterList.removeAll();
				
				if((resultObj.deliverySideDetail.businessCenterList != null) 
					&& (resultObj.deliverySideDetail.businessCenterList.businessCenter != null)){
					
	                if(resultObj.deliverySideDetail.businessCenterList.businessCenter is ArrayCollection){
	                	businessCenterList = resultObj.deliverySideDetail.businessCenterList.businessCenter as ArrayCollection;
	                }else{
	                	businessCenterList.addItem(resultObj.deliverySideDetail.businessCenterList.businessCenter);
	                }
	                businessCenterList.refresh();
				}
				if(editFlag){
					if(resultObj.deliverySideDetail.businessCenterDetail != null){						
						editBusCenterMode = true;
						delMarketTree.itemCombo.text = resultObj.deliverySideDetail.businessCenterDetail.finInstCode;
						var basis:String = resultObj.deliverySideDetail.businessCenterDetail.basis;
						delBasis.selectedIndex = getIndexOfLabelValueBean(delBasisList, basis);
					}
				}else {
					delMarketTree.itemCombo.text = "";
				    delBasis.selectedIndex = 0;
					editBusCenterMode = false;
				}
			}
		}else {
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
	}else {
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	}
}

/**
 * To add PaymentSchedule Information
 */
private function addPaymentSchedule():void {
	if(validatePaymentSchedule()){
		return;
	}
	editPSFlag = false;
	var reqObj:Object = populatePaymentScheduleRequest();
	addPaymentScheduleService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=addPaymentSchedule";
	} else if (XenosStringUtils.equals(mode , "amend") 
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=addPaymentSchedule";
	}
	addPaymentScheduleService.url = url ;
	addPaymentScheduleService.send();
}
/**
 * To cancel PaymentSchedule Information
 */
private function cancelPaymentSchedule():void {
	var reqObj : Object = new Object();
	editPSFlag = false;
	reqObj.editIndexPaymentSchedule = editPmntSchdlIndex;
	reqObj.srcTabNo = "2";
	addPaymentScheduleService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=cancelPaymentSchedule";
	} else if (XenosStringUtils.equals(mode , "amend") 
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=cancelPaymentSchedule";
	}
	addPaymentScheduleService.url = url;
	addPaymentScheduleService.send();
}
/**
 * To save PaymentSchedule Information
 */
private function savePaymentSchedule():void {
	if(validatePaymentSchedule()){
		return;
	}
	editPSFlag = false;
	var reqObj:Object = populatePaymentScheduleRequest();
	reqObj.editIndexPaymentSchedule = editPmntSchdlIndex;
	addPaymentScheduleService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=savePaymentSchedule";
	} else if (XenosStringUtils.equals(mode , "amend") 
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=savePaymentSchedule";
	}
	addPaymentScheduleService.url = url ;
	addPaymentScheduleService.send();
}
/**
 * To edit Payment Schedule Information
 */        
public function editPaymentSchedule(data:Object):void {
	var reqObj : Object = new Object();
	editPSFlag = true;
	editPmntSchdlIndex = paymentScheduleList.getItemIndex(data);
	reqObj.editIndexPaymentSchedule = editPmntSchdlIndex;
	reqObj.srcTabNo = "2";
	addPaymentScheduleService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=editPaymentSchedule";
	} else if (XenosStringUtils.equals(mode , "amend") 
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=editPaymentSchedule";
	}
	addPaymentScheduleService.url = url;
	addPaymentScheduleService.send();
}
/**
 * To delete Payment Schedule Information
 */        
public function deletePaymentSchedule(data:Object):void {
	var reqObj : Object = new Object();
	editPSFlag = false;
	editPmntSchdlIndex = paymentScheduleList.getItemIndex(data);
	reqObj.editIndexPaymentSchedule = editPmntSchdlIndex;
	reqObj.srcTabNo = "2";
	addPaymentScheduleService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=deletePaymentSchedule";
	} else if (XenosStringUtils.equals(mode , "amend") 
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=deletePaymentSchedule";
	}
	addPaymentScheduleService.url = url ;
	addPaymentScheduleService.send();
}
/**
* This method works as the result handler of the payment schedule.
*/
public function addPaymentScheduleResult(event:ResultEvent):void {
	
	if(event != null){
		if(event.result != null){
			if(event.result.hasOwnProperty("XenosErrors") &&
			   event.result.XenosErrors != null){
				if(event.result.XenosErrors.Errors != null){
					if(event.result.XenosErrors.Errors.error != null){
						errPage.removeError();
						var errorInfoList : ArrayCollection = new ArrayCollection();
						if(event.result.XenosErrors.Errors.error is ArrayCollection){
	    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
	    				}else{
	    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
	    				}
	    				errPage.showError(errorInfoList);
					}
				}
			}else {
				var resultObj:Object = event.result.swpEntryActionForm;
				errPage.clearError(event);
				paymentScheduleList.removeAll();
				
				if((resultObj.deliverySideDetail.paymentScheduleList != null) 
					&& (resultObj.deliverySideDetail.paymentScheduleList.paymentSchedule != null)){
					if(resultObj.deliverySideDetail.paymentScheduleList.paymentSchedule is ArrayCollection){
	                	paymentScheduleList = resultObj.deliverySideDetail.paymentScheduleList.paymentSchedule as ArrayCollection;
	                } else{
	                	paymentScheduleList.addItem(resultObj.deliverySideDetail.paymentScheduleList.paymentSchedule);
	                }
		         	paymentScheduleList.refresh();
				}
				if(editPSFlag){
					if(resultObj.deliverySideDetail.paymentScheduleDetail != null){						
						editPaymentScheduleMode = true;
						var month:String = resultObj.deliverySideDetail.paymentScheduleDetail.paymentMonthStr;
						delPaymentMonth.selectedIndex = getIndexOfLabelValueBean(delPaymentMonthList, month);
						var day:String = resultObj.deliverySideDetail.paymentScheduleDetail.paymentDay;
						delPaymentDay.selectedIndex = getIndexOfLabelValueBean(delPaymentDayList, day);
					}
				}else {
					delPaymentMonth.selectedIndex = 0;
			        delPaymentDay.selectedIndex = 0;
			        editPaymentScheduleMode = false;
				}
			}
		}else {
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
	}else {
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	}
}
/**
 * validates business center  
 */
private function validateBusinesscenter():Boolean {
	var errorStr:String = XenosStringUtils.EMPTY_STR;
	if(XenosStringUtils.isBlank(delMarketTree.itemCombo.text)){
		errorStr += "Market can not be empty";
	}
    if(XenosStringUtils.isBlank(delBasis.selectedItem.value)){
		errorStr += "\nBasis can not be empty";
	}
	if(!XenosStringUtils.equals(errorStr,XenosStringUtils.EMPTY_STR)){
		XenosAlert.error(errorStr);
		return true;
	}
	return false;
}
/**
 * populates Business Center Request
 */
private function populateBusinessCenterRequest():Object {
	
	var obj : Object = new Object();
	obj.srcTabNo = "2";
	obj['deliverySideStreamObj.businessCenterObj.finInstCode'] = delMarketTree.itemCombo.text;
	obj['deliverySideStreamObj.businessCenterObj.basis'] = delBasis.selectedItem.value;
	return obj;
}
/**
 * validates Payment Schedule
 */
private function validatePaymentSchedule():Boolean {
	var errorStr:String = XenosStringUtils.EMPTY_STR;
	
	var day:String = delPaymentDay.selectedItem.value;
	var month:String = delPaymentMonth.selectedItem.value;
	
	if(XenosStringUtils.isBlank(day)){
		errorStr += "Payment Day can not be empty";
	}
    if(XenosStringUtils.isBlank(month)){
		errorStr += "\nPayment Month can not be empty";
	}
	
	if(XenosStringUtils.equals(day, "31")
					 && (XenosStringUtils.equals(month, "1")
					 || XenosStringUtils.equals(month, "3")
					 || XenosStringUtils.equals(month, "5")
					 || XenosStringUtils.equals(month, "8")
					 || XenosStringUtils.equals(month, "10"))){
		errorStr += "\n31st day is not present in the specified month";
	}else if(XenosStringUtils.equals(day, "30")&& XenosStringUtils.equals(month, "1")){
		errorStr += "\n30th day is not present in the month of February";
	}else if(XenosStringUtils.equals(day, "29")&& XenosStringUtils.equals(month, "1")){
		errorStr += "\n29th day can not entered for the month of February";
	}
	if(!XenosStringUtils.equals(errorStr,XenosStringUtils.EMPTY_STR)){
		XenosAlert.error(errorStr);
		return true;
	}
	return false;
}
/**
 * populates Payment Schedule Request
 */
private function populatePaymentScheduleRequest():Object {
	
	var obj : Object = new Object();
	obj.srcTabNo = "2";
	obj['deliverySideStreamObj.paymentScheduleObj.paymentDay'] = delPaymentDay.selectedItem.value;
	obj['deliverySideStreamObj.paymentScheduleObj.paymentMonthStr'] = delPaymentMonth.selectedItem.value;
	
	return obj;
}