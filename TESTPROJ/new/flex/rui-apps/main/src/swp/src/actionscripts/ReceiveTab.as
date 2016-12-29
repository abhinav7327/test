

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
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

[Bindable]public var recFixedfFoatingTypeList:ArrayCollection = new ArrayCollection();
[Bindable]public var recIntRateTypeList:ArrayCollection = new ArrayCollection();
[Bindable]public var recAccruedCalBasisList:ArrayCollection = new ArrayCollection();
[Bindable]public var recAccruedAdjustmentList:ArrayCollection = new ArrayCollection();
[Bindable]public var recPaymentAdjustmentTypeList:ArrayCollection = new ArrayCollection();
[Bindable]public var recPaymentFreqList:ArrayCollection = new ArrayCollection();
[Bindable]public var recRoundingPolicyList:ArrayCollection = new ArrayCollection();
[Bindable]public var recBasisList:ArrayCollection = new ArrayCollection();
[Bindable]public var recPaymentMonthList:ArrayCollection = new ArrayCollection();
[Bindable]public var recPaymentDayList:ArrayCollection = new ArrayCollection();

[Bindable]public var editBusCenterMode:Boolean = false;
[Bindable]public var editPaymentScheduleMode:Boolean = false;
[Bindable]private var editBusCntrIndex:int = -1;
[Bindable]private var editPmntSchdlIndex:int = -1;

private var editFlag:Boolean = false;
private var editPSFlag:Boolean = false;

[Bindable] private var terminationMode : Boolean = false ;

override public function initPage(response:XML):void
{
	var obj:Object=new Object();
	xml = response as XML;
	
	if (XenosStringUtils.equals(xml.modeOfOperation , "TERMINATION")) {
		terminationMode = true ;
	}
	
	var notionalExchange:String = xml.trade.notionalExchangeFlag;
	if(XenosStringUtils.equals(notionalExchange, Globals.DATABASE_NO)){
		recNotionalAmt.text = xml.deliverySideDetail.streamDetail.notionalAmountStr;
		recNotionalAmt.enabled = false;
		recPaymentCcy.ccyText.text = xml.deliverySideDetail.streamDetail.paymentCcyStr;
		recPaymentCcy.enabled = false;
	}else { 
		recNotionalAmt.text = xml.receiveSideDetail.streamDetail.notionalAmountStr;
		recNotionalAmt.enabled = true;
		recPaymentCcy.ccyText.text = xml.receiveSideDetail.streamDetail.paymentCcyStr;
		recPaymentCcy.enabled = true;
	}
    
    recFixedfFoatingTypeList.removeAll();
    recFixedfFoatingTypeList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.fixedFloatingTypeList.item){
        recFixedfFoatingTypeList.addItem(obj);
    }
    recFixedfFoatingType.selectedIndex = getIndexOfLabelValueBean(recFixedfFoatingTypeList, xml.receiveSideDetail.streamDetail.fixedFloatingType);
    checkRateType();
    
    recFixedIntRate.text = xml.receiveSideDetail.streamDetail.fixedInterestRateVal;
    
    recIntRateTypeList.removeAll();
    recIntRateTypeList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.interestRateType.item){
        recIntRateTypeList.addItem(obj);
    }
    recIntRateType.selectedIndex = getIndexOfLabelValueBean(recIntRateTypeList, xml.receiveSideDetail.streamDetail.interestRateTypes);
    
    recOffsetFloatingIntRate.text =  xml.receiveSideDetail.streamDetail.spreadVal;
    recResetDateOffset.text = xml.receiveSideDetail.streamDetail.resetDateOffsetStr;
    
    recAccruedCalBasisList.removeAll();
    recAccruedCalBasisList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.accrualBasisList.item){
        recAccruedCalBasisList.addItem(obj);
    }
    recAccruedCalBasis.selectedIndex = getIndexOfLabelValueBean(recAccruedCalBasisList, xml.receiveSideDetail.streamDetail.dayCountFractionBasis);
    
    recAccruedAdjustmentList.removeAll();
    recAccruedAdjustmentList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.accrualAdjustmentFlagList.item){
        recAccruedAdjustmentList.addItem(obj);
    }
    recAccruedAdjustment.selectedIndex = getIndexOfLabelValueBean(recAccruedAdjustmentList, xml.receiveSideDetail.streamDetail.accruedAdjustmentFlag);
    
    recPaymentAdjustmentTypeList.removeAll();
    recPaymentAdjustmentTypeList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.dayConventionList.item){
        recPaymentAdjustmentTypeList.addItem(obj);
    }
    recPaymentAdjustmentType.selectedIndex = getIndexOfLabelValueBean(recPaymentAdjustmentTypeList, xml.receiveSideDetail.streamDetail.dayConvention);
    
    recPaymentFreqList.removeAll();
    recPaymentFreqList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.paymentFrequencyList.item){
        recPaymentFreqList.addItem(obj);
    }
    recPaymentFreq.selectedIndex = getIndexOfLabelValueBean(recPaymentFreqList, xml.receiveSideDetail.streamDetail.paymentFrequency);
    
    recFirstPaymentDate.text = xml.receiveSideDetail.streamDetail.firstValueDateStr;
    
	recLastRegularPaymentDate.text = xml.receiveSideDetail.streamDetail.lastRegularValueDateStr;
    
    recRoundingPolicyList.removeAll();
    recRoundingPolicyList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.roundingPolicyList.item){
        recRoundingPolicyList.addItem(obj);
    }
    recRoundingPolicy.selectedIndex = getIndexOfLabelValueBean(recRoundingPolicyList, xml.receiveSideDetail.streamDetail.roundingPolicy);
    
    //Business center fields population
	recMarketTree.itemCombo.text = xml.receiveSideDetail.businessCenterDetail.finInstCode;    
    
    recBasisList.removeAll();
    recBasisList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.businessCenterBasisList.item){
        recBasisList.addItem(obj);
    }
    recBasis.selectedIndex = getIndexOfLabelValueBean(recBasisList, xml.receiveSideDetail.businessCenterDetail.basis);
    //Business center results population
    businessCenterList.removeAll();
	for each(obj in xml.receiveSideDetail.businessCenterList.businessCenter){
        businessCenterList.addItem(obj);
    }
    //Payment schedule fields population
    recPaymentMonthList.removeAll();
    recPaymentMonthList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.paymentMonthList.item){
        recPaymentMonthList.addItem(obj);
    }
    recPaymentMonth.selectedIndex = getIndexOfLabelValueBean(recPaymentMonthList, xml.receiveSideDetail.paymentScheduleDetail.paymentMonthStr);
    
    recPaymentDayList.removeAll();
    recPaymentDayList.addItem({label:"SELECT", value:""});
    for each(obj in xml.swapFormListValues.paymentDayList.item){
        recPaymentDayList.addItem(obj);
    }
    recPaymentDay.selectedIndex = getIndexOfLabelValueBean(recPaymentDayList, xml.receiveSideDetail.paymentScheduleDetail.paymentDay);
	//Payment schedule results population
	paymentScheduleList.removeAll();
    for each(obj in xml.receiveSideDetail.paymentScheduleList.paymentSchedule){
        paymentScheduleList.addItem(obj);
    }
}
/**
 * validate receive tab
 */
override public function  validate():ValidationResultEvent {
    var validator:TradeDeliverReceiveEntryValidator = new TradeDeliverReceiveEntryValidator();
    var model:Object = populateRequest();
    return validator.validate(model);        	
}
/**
 * populate receive tab
 */
override public function populateRequest():Object {
	
	var reqObj:Object = new Object();
	reqObj.srcTabNo = "3";
	
	reqObj['SCREEN_KEY'] 					   							= 12032;//need to change during amend
    reqObj['receiveSideStreamObj.streamObj.dayCountFractionBasis']		= StringUtil.trim(this.recAccruedCalBasis.selectedItem != null? this.recAccruedCalBasis.selectedItem.value: "");
    reqObj['receiveSideStreamObj.streamObj.accruedAdjustmentFlag']		= StringUtil.trim(this.recAccruedAdjustment.selectedItem != null? this.recAccruedAdjustment.selectedItem.value: "");
    reqObj['receiveSideStreamObj.streamObj.dayConvention']				= StringUtil.trim(this.recPaymentAdjustmentType.selectedItem != null? this.recPaymentAdjustmentType.selectedItem.value: "");
    reqObj['receiveSideStreamObj.streamObj.firstValueDateStr']			= StringUtil.trim(recFirstPaymentDate.text);
    reqObj['receiveSideStreamObj.streamObj.lastRegularValueDateStr']	= StringUtil.trim(recLastRegularPaymentDate.text);
    /* var amount:String = StringUtil.trim(recNotionalAmt.text);
    amount = amount.replace(/\,/g, ''); */
    reqObj['receiveSideStreamObj.streamObj.notionalAmountStr']			= StringUtil.trim(recNotionalAmt.text);
    reqObj['receiveSideStreamObj.streamObj.paymentCcyStr']				= StringUtil.trim(recPaymentCcy.ccyText.text);
    reqObj['receiveSideStreamObj.streamObj.paymentFrequency']		    = StringUtil.trim(this.recPaymentFreq.selectedItem != null? this.recPaymentFreq.selectedItem.value: "");
    reqObj['receiveSideStreamObj.streamObj.roundingPolicy']				= StringUtil.trim(this.recRoundingPolicy.selectedItem != null? this.recRoundingPolicy.selectedItem.value: "");
    
    var fixedFloatingType:String = StringUtil.trim(this.recFixedfFoatingType.selectedItem != null? this.recFixedfFoatingType.selectedItem.value: ""); 
    reqObj['receiveSideStreamObj.streamObj.fixedFloatingType']			= fixedFloatingType;
    if(XenosStringUtils.equals(fixedFloatingType,Globals.FIXED_TYPE)){
    	reqObj['receiveSideStreamObj.streamObj.fixedInterestRateVal']		= StringUtil.trim(recFixedIntRate.text);    
    	reqObj['receiveSideStreamObj.streamObj.interestRateTypes']			= "";
    	reqObj['receiveSideStreamObj.streamObj.spreadVal']					= "";
    	reqObj['receiveSideStreamObj.streamObj.resetDateOffsetStr']		= "";
    }else if(XenosStringUtils.equals(fixedFloatingType,Globals.FLOATING_TYPE)){
    	reqObj['receiveSideStreamObj.streamObj.fixedInterestRateVal']		= "";    
    	reqObj['receiveSideStreamObj.streamObj.interestRateTypes']			= StringUtil.trim(this.recIntRateType.selectedItem != null? this.recIntRateType.selectedItem.value: "");
    	reqObj['receiveSideStreamObj.streamObj.spreadVal']					= StringUtil.trim(recOffsetFloatingIntRate.text);
    	reqObj['receiveSideStreamObj.streamObj.resetDateOffsetStr']		= StringUtil.trim(recResetDateOffset.text);
    }else {
    	reqObj['receiveSideStreamObj.streamObj.fixedInterestRateVal']		= "";    
    	reqObj['receiveSideStreamObj.streamObj.interestRateTypes']			= "";
    	reqObj['receiveSideStreamObj.streamObj.spreadVal']					= "";
    	reqObj['receiveSideStreamObj.streamObj.resetDateOffsetStr']		= "";
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
    var selVal:String = recFixedfFoatingType.selectedItem.value;
    
    if(XenosStringUtils.equals(selVal,Globals.FIXED_TYPE)) {	
		recFixedIntRate.visible = true;
		recFixedIntRate.includeInLayout = true;
		recFixedIntRateLabel.visible = true;
		recFixedIntRateLabel.includeInLayout = true;
		
		recIntRateType.visible = false;
		recIntRateType.includeInLayout = false;				
		recIntRateTypeLabel.visible = false;
		recIntRateTypeLabel.includeInLayout = false;
		
		recFloatingRow.visible = false;
		recFloatingRow.includeInLayout = false;
		
		recIntRateType.selectedIndex = 0;
		recOffsetFloatingIntRate.text = "";
		recResetDateOffset.text = "";					
	} else if(XenosStringUtils.equals(selVal,Globals.FLOATING_TYPE)) {
		recFixedIntRate.visible = false;
		recFixedIntRate.includeInLayout = false;
		recFixedIntRateLabel.visible = false;
		recFixedIntRateLabel.includeInLayout = false;
        
		recIntRateType.visible = true;
		recIntRateType.includeInLayout = true;				
		recIntRateTypeLabel.visible = true;
		recIntRateTypeLabel.includeInLayout = true;
        
        recFloatingRow.visible = true;
		recFloatingRow.includeInLayout = true;
		
		recFixedIntRate.text = "";
	} else {
		recFixedIntRate.visible = false;
		recFixedIntRate.includeInLayout = false;
		recFixedIntRateLabel.visible = false;
		recFixedIntRateLabel.includeInLayout = false;
        
        recIntRateType.visible = false;
		recIntRateType.includeInLayout = false;				
		recIntRateTypeLabel.visible = false;
		recIntRateTypeLabel.includeInLayout = false;
        
        recFloatingRow.visible = false;
		recFloatingRow.includeInLayout = false;
		
		recIntRateType.selectedIndex = 0;
		recOffsetFloatingIntRate.text = "";
		recResetDateOffset.text = "";
		recFixedIntRate.text = "";
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
	reqObj.editIndexBusinessCenter = editBusCntrIndex;
	reqObj.srcTabNo = "3";
	addBusinessCenterService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=cancelBusinessCenter";
	} else if (XenosStringUtils.equals(mode , "amend")
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=cancelBusinessCenter";
	}
	addBusinessCenterService.url = url;
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
	addBusinessCenterService.url = url;
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
	reqObj.srcTabNo = "3";
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
	reqObj.srcTabNo = "3";
	addBusinessCenterService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=deleteBusinessCenter";
	} else if (XenosStringUtils.equals(mode , "amend")
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=deleteBusinessCenter";
	}
	addBusinessCenterService.url = url;
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
				
				if((resultObj.receiveSideDetail.businessCenterList != null) 
					&& (resultObj.receiveSideDetail.businessCenterList.businessCenter != null)){
					
	                if(resultObj.receiveSideDetail.businessCenterList.businessCenter is ArrayCollection){
	                	businessCenterList = resultObj.receiveSideDetail.businessCenterList.businessCenter as ArrayCollection;
	                }else{
	                	businessCenterList.addItem(resultObj.receiveSideDetail.businessCenterList.businessCenter);
	                }
	                businessCenterList.refresh();
				}
				if(editFlag){
					if(resultObj.receiveSideDetail.businessCenterDetail != null){						
						editBusCenterMode = true;
						recMarketTree.itemCombo.text = resultObj.receiveSideDetail.businessCenterDetail.finInstCode;
						var basis:String = resultObj.receiveSideDetail.businessCenterDetail.basis;
						recBasis.selectedIndex = getIndexOfLabelValueBean(recBasisList, basis);
					}
				}else {
					recMarketTree.itemCombo.text = "";
					recBasis.selectedIndex = 0;
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
	reqObj.srcTabNo = "3";
	addPaymentScheduleService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=cancelPaymentSchedule";
	} else if (XenosStringUtils.equals(mode , "amend") 
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=cancelPaymentSchedule";
	}
	addPaymentScheduleService.url = url ;
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
	reqObj.srcTabNo = "3";
	addPaymentScheduleService.request = reqObj;
	var url : String  = "";
	if (XenosStringUtils.equals(mode , "ENTRY")) {
		url = "swp/swpTradeEntryDispatch.action?method=editPaymentSchedule";
	} else if (XenosStringUtils.equals(mode , "amend") 
				|| XenosStringUtils.equals(mode , "AMEND")) {
		url = "swp/swpTradeAmendDispatch.action?method=editPaymentSchedule";
	}
	addPaymentScheduleService.url = url ;
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
	reqObj.srcTabNo = "3";
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

				if((resultObj.receiveSideDetail.paymentScheduleList != null) 
					&& (resultObj.receiveSideDetail.paymentScheduleList.paymentSchedule != null)) {
	                if(resultObj.receiveSideDetail.paymentScheduleList.paymentSchedule is ArrayCollection){
	                	paymentScheduleList = resultObj.receiveSideDetail.paymentScheduleList.paymentSchedule as ArrayCollection;
	                } else{
	                	paymentScheduleList.addItem(resultObj.receiveSideDetail.paymentScheduleList.paymentSchedule);
	                }
		         	paymentScheduleList.refresh();
				}
				if(editPSFlag){
					if(resultObj.receiveSideDetail.paymentScheduleDetail != null){						
						editPaymentScheduleMode = true;
						var month:String = resultObj.receiveSideDetail.paymentScheduleDetail.paymentMonthStr;
						recPaymentMonth.selectedIndex = getIndexOfLabelValueBean(recPaymentMonthList, month);
						var day:String = resultObj.receiveSideDetail.paymentScheduleDetail.paymentDay;
						recPaymentDay.selectedIndex = getIndexOfLabelValueBean(recPaymentDayList, day);
					}
				}else {
					recPaymentMonth.selectedIndex = 0;
			        recPaymentDay.selectedIndex = 0;
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
	if(XenosStringUtils.isBlank(recMarketTree.itemCombo.text)){
		errorStr += "Market can not be empty";
	}
    if(XenosStringUtils.isBlank(recBasis.selectedItem.value)){
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
	obj.srcTabNo = "3";
	obj['receiveSideStreamObj.businessCenterObj.finInstCode'] = recMarketTree.itemCombo.text;
	obj['receiveSideStreamObj.businessCenterObj.basis'] = recBasis.selectedItem.value;
	return obj;
}
/**
 * validates Payment Schedule
 */
private function validatePaymentSchedule():Boolean {
	var errorStr:String = XenosStringUtils.EMPTY_STR;
	
	var day:String = recPaymentDay.selectedItem.value;
	var month:String = recPaymentMonth.selectedItem.value;
	
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
	obj.srcTabNo = "3";
	obj['receiveSideStreamObj.paymentScheduleObj.paymentDay'] = recPaymentDay.selectedItem.value;
	obj['receiveSideStreamObj.paymentScheduleObj.paymentMonthStr'] = recPaymentMonth.selectedItem.value;
	
	return obj;
}