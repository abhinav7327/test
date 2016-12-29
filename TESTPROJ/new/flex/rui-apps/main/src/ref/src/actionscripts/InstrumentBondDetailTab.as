

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.formatters.CustomDateFormatter;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.validators.InstrumentBondDetailValidator;

import flash.events.Event;
import flash.events.FocusEvent;

import mx.collections.ArrayCollection;
import mx.events.ListEvent;
import mx.events.ValidationResultEvent;
import mx.managers.IPopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
import mx.validators.ValidationResult; 
   			
private var iPopUpManager:IPopUpManager;

[Bindable]private var bondTypes:ArrayCollection;
[Bindable]private var pdFlagValues:ArrayCollection;
[Bindable]private var tipsFlagValues:ArrayCollection;
[Bindable]private var tipsBaseValues:ArrayCollection;
[Bindable]private var stripTypeValues:ArrayCollection;

[Bindable]private var couponFrequencyValues:ArrayCollection;
[Bindable]private var accIntCalTypeValues:ArrayCollection;
[Bindable]private var couponTypeValues:ArrayCollection;
[Bindable]private var rateTypeValues:ArrayCollection;
[Bindable]private var paymentMonthList:ArrayCollection;
[Bindable]private var paymentDayList:ArrayCollection;
[Bindable]private var floatingBaseRateValues:ArrayCollection;
[Bindable]private var principalPaymentFreqValues:ArrayCollection;
[Bindable]private var businessDayConventions:ArrayCollection;
[Bindable]private var dirtyPriceFlags:ArrayCollection;
[Bindable]private var fixedCouponDaysFlag:ArrayCollection;
[Bindable]private var investmentBondCategoryList:ArrayCollection;
[Bindable]private var euroYenBondFlagList:ArrayCollection;


[Bindable]private var accrualStartDateSummaryResult:ArrayCollection = new ArrayCollection();
[Bindable]private var couponInfoSummaryResult:ArrayCollection = new ArrayCollection();

[Bindable]private var monthValues:ArrayCollection;
[Bindable]private var dayValues:ArrayCollection;
private var noOfDaysinMonth:Object={1:31,2:28,3:31,4:30,5:31,6:30,7:31,8:31,9:30,10:31,11:30,12:31};
private var hiddenCouponPaymentFreq:int;
private var hiddenDiscountCouponType:int;
private var hiddenFloatingFixFlag:int;
//private var hiddentFixedCpFlag:int;
public static const millisecondsPerDay:int = 1000 * 60 * 60 * 24;

[Bindable]public var xml:XML;


override public function populateRequest():Object{
	var reqObj:Object = new Object();
	reqObj['instrumentPage.discountCouponType'] = StringUtil.trim(this.bondType.selectedItem.value);
	reqObj['instrumentPage.issuePriceStr'] = this.issuePrice.text;
	reqObj['instrumentPage.redemptionCcy'] = this.redmpnCcy.ccyText.text;
	reqObj['instrumentPage.redemptionPriceStr'] = this.redmpnPrice.text;
	reqObj['instrumentPage.issueDateStr'] = this.issueDate.text;
	reqObj['instrumentPage.maturityDateStr'] = this.maturityDate.text;
	reqObj['instrumentPage.delayDaysStr'] = this.delayDays.text;
	reqObj['instrumentPage.payDownFlag'] = StringUtil.trim(this.pdFlag.selectedItem.value);
	reqObj['instrumentPage.tipsFlag'] = StringUtil.trim(this.tipsFlag.selectedItem.value);
	reqObj['instrumentPage.tipsBase'] = StringUtil.trim(this.tipsBase.selectedItem.toString());
	reqObj['instrumentPage.stripType'] = StringUtil.trim(this.stripType.selectedItem.value);
	reqObj['instrumentPage.recordDaysStr'] = this.recordDays.text;
	reqObj['instrumentPage.principalPaymentFreqStr'] = StringUtil.trim(this.principalPaymentFreqStr.selectedItem.value);

 if(reqObj['instrumentPage.discountCouponType'] == 'COUPON'){
	reqObj['instrumentPage.couponPaymentFreqStr'] = StringUtil.trim(this.couponFrequency.selectedItem.value);
	reqObj['instrumentPage.couponCcy'] = this.couponCcy.ccyText.text;
	reqObj['instrumentPage.accruedInterestInitDateStr'] = this.accIntStartDate.text;
	reqObj['instrumentPage.accruedInterestCalcType'] = StringUtil.trim(this.accIntCalType.selectedItem.toString());
	reqObj['instrumentPage.initialCouponDateStr'] = this.initialCouponDate.text;
	reqObj['instrumentPage.initialCouponType'] = StringUtil.trim(this.initialCouponType.selectedItem.value);
	reqObj['instrumentPage.finalCouponType'] = StringUtil.trim(this.finalCouponType.selectedItem.value);
	reqObj['instrumentPage.floatingFixFlag'] = StringUtil.trim(this.rateType.selectedItem.value);
	reqObj['instrumentPage.businessDayConvention'] = StringUtil.trim(this.businessDayConvention.selectedItem.value);
	if(this.mode == "amend"){
		reqObj['instrumentPage.dirtyPriceFlag'] = (StringUtil.trim(this.dirtyPriceFlag.selectedItem.value)== "YES") ? "Y":StringUtil.trim(this.dirtyPriceFlag.selectedItem.value);
	}
	reqObj['instrumentPage.investBondCategory'] =  StringUtil.trim(this.investmentBondCategory.selectedItem.value);
	reqObj['instrumentPage.euroYenBondFlag'] = StringUtil.trim(this.euroYenBondFlag.selectedItem.value);
	//XenosAlert.info(this.rateType.selectedItem.value.toString());
	if(StringUtil.trim(this.rateType.selectedItem.value) == "FIX"){
		reqObj['instrumentPage.fixedCouponRateStr'] = this.fixedCouponRate.text;
		reqObj['instrumentPage.floatingBaseRate'] = "";
		reqObj['instrumentPage.couponResetDateStr'] = "";
	}else if(StringUtil.trim(this.rateType.selectedItem.value) == "FLOAT"){
		reqObj['instrumentPage.floatingBaseRate'] = StringUtil.trim(this.floatingBaseRate.selectedItem.value);
		reqObj['instrumentPage.couponResetDateStr'] = this.couponResetDate.text;
		reqObj['instrumentPage.fixedCouponRateStr'] = "";
	}
	//XenosAlert.info(this.fixedCouponDayFlag.selectedItem.value);
		//XenosAlert.info("extra object populated");
		reqObj['instrumentPage.fixedDaysCouponFlag'] = (StringUtil.trim(this.fixedCouponDayFlag.selectedItem.value)== "YES") ? "Y":StringUtil.trim(this.fixedCouponDayFlag.selectedItem.value);
		reqObj['instrumentPage.prevCouponDateStr'] = this.prevCouponDate.text;
		reqObj['instrumentPage.nextCouponDateStr'] = this.nextCouponDate.text;
		reqObj['instrumentPage.fixedCouponDaysStr'] = this.fixedCouponDays.text;
 }
 	if(this.mode == "entry")
		reqObj['SCREEN_KEY'] = 20;
	else 
		reqObj['SCREEN_KEY'] = 25;
 
	return reqObj;
}

override public function reset():void {
}

override public function initPage(response:XML):void {

	xml = response as XML;
	
	//Bond Type
	bondTypes = new ArrayCollection();
	bondTypes.addItem({label:" ", value:" "});
	for each(var xmlObj:Object in xml.instrumentPage.discountCouponTypeValue.item){
		bondTypes.addItem(xmlObj);
	}
	bondType.selectedIndex = getIndexOfLabelValueBean(bondTypes, xml.instrumentPage.discountCouponType);
	hiddenCouponPaymentFreq = 0;
    hiddenDiscountCouponType =0;
    hiddenFloatingFixFlag = 0;
    //hiddentFixedCpFlag = 0;
	
	// Issue Price
	issuePrice.text = xml.instrumentPage.issuePriceStr;
	
	//Redemption Ccy
	redmpnCcy.ccyText.text = xml.instrumentPage.redemptionCcy;
	
	//Redemption Price
	redmpnPrice.text = xml.instrumentPage.redemptionPriceStr;
	
	//Issue Date
	issueDate.text = xml.instrumentPage.issueDateStr;
	
	//Maturity Date
	maturityDate.text = xml.instrumentPage.maturityDateStr;
	
	//Delay Days
	delayDays.text = xml.instrumentPage.delayDaysStr;
	
	couponResetDate.text = xml.instrumentPage.couponResetDateStr;
	fixedCouponRate.text = xml.instrumentPage.fixedCouponRateStr;
	couponCcy.ccyText.text = xml.instrumentPage.couponCcy;
	initialCouponDate.text = xml.instrumentPage.initialCouponDateStr;
	accIntStartDate.text = xml.instrumentPage.accruedInterestInitDateStr;
			
	//Pay Down Flag
	pdFlagValues = new ArrayCollection();
	pdFlagValues.addItem({label:" ", value:" "});
	for each(var xmlObjPD:Object in xml.instrumentPage.payDownFlagValue.item){
		pdFlagValues.addItem(xmlObjPD);
	}
	pdFlag.selectedIndex = getIndexOfLabelValueBean(pdFlagValues, xml.instrumentPage.payDownFlag);
	
	//Tips Flag
	tipsFlagValues = new ArrayCollection();
	for each(var xmlObjTF:Object in xml.instrumentPage.tipsFlagValue.item){
		tipsFlagValues.addItem(xmlObjTF);
	}
	tipsFlag.selectedIndex = getIndexOfLabelValueBean(tipsFlagValues, xml.instrumentPage.tipsFlag);
	
	//Tips Base
	tipsBaseValues = new ArrayCollection();
	tipsBaseValues.addItem(" ");
	for each(var xmlObjTB:Object in xml.instrumentPage.tipsBaseValueList.tipsBaseValue){
		tipsBaseValues.addItem(xmlObjTB);
	}
	tipsBase.selectedIndex = getIndex(tipsBaseValues, xml.instrumentPage.tipsBase);
	
	//Strip Type
	stripTypeValues = new ArrayCollection();
	stripTypeValues.addItem({label:" ", value:" "});
	for each(var xmlObjST:Object in xml.instrumentPage.stripTypeValue.item){
		stripTypeValues.addItem(xmlObjST);
	}
	stripType.selectedIndex = getIndexOfLabelValueBean(stripTypeValues, xml.instrumentPage.stripType);
	
	//Record Days
	recordDays.text = xml.instrumentPage.recordDaysStr;
	
	//added
	
	couponFrequencyValues = new ArrayCollection();
	couponFrequencyValues.addItem({label: " " , value : " "});
	for each(var xmlObj1:Object in xml.instrumentPage.couponPaymentFreqValues.item){
		couponFrequencyValues.addItem(xmlObj1);
	}
	couponFrequency.selectedIndex = getIndexOfLabelValueBean(couponFrequencyValues, xml.instrumentPage.couponPaymentFreqStr);
	
	accIntCalTypeValues = new ArrayCollection();
	accIntCalTypeValues.addItem(" ");
	for each(var xmlObj2:Object in xml.instrumentPage.accruedInterestCalcTypeValuesWrapper.accruedInterestCalcTypeValues){
		accIntCalTypeValues.addItem(xmlObj2);
	}
	accIntCalType.selectedIndex = getIndex(accIntCalTypeValues, xml.instrumentPage.accruedInterestCalcType);
	
	couponTypeValues = new ArrayCollection();
	couponTypeValues.addItem({label: " " , value : " "});
	for each(var xmlObj3:Object in xml.instrumentPage.couponTypeValues.item){
		couponTypeValues.addItem(xmlObj3);
	}
	initialCouponType.selectedIndex = getIndexOfLabelValueBean(couponTypeValues, xml.instrumentPage.initialCouponType);
	finalCouponType.selectedIndex = getIndexOfLabelValueBean(couponTypeValues, xml.instrumentPage.finalCouponType);
	//Business day conventions
	businessDayConventions = new ArrayCollection();
	businessDayConventions.addItem({label: " ", value: " "});
	for each(var xmlObj3:Object in xml.instrumentPage.businessDayConventions.item){
		businessDayConventions.addItem(xmlObj3);
	}
	businessDayConvention.selectedIndex = getIndexOfLabelValueBean(businessDayConventions, xml.instrumentPage.businessDayConvention);
	
	dirtyPriceFlags = new ArrayCollection();
	dirtyPriceFlags.addItem({label: " ", value: " "});
	for each(var xmlObj3:Object in xml.instrumentPage.dirtyPriceFlagValues.item){
		dirtyPriceFlags.addItem(xmlObj3);
	}
	dirtyPriceFlag.selectedIndex = 0;
	if(xml.instrumentPage.dirtyPriceFlag == "Y"){
		dirtyPriceFlag.selectedIndex = getIndexOfLabelValueBean(dirtyPriceFlags, "Y");
	}
	else{
		dirtyPriceFlag.selectedIndex = 0;
	}
	
	fixedCouponDaysFlag = new ArrayCollection();
	fixedCouponDaysFlag.addItem({label: " ", value: " "});
	for each(var xmlObj3:Object in xml.instrumentPage.fixedCouponDaysFlagValue.item){
		fixedCouponDaysFlag.addItem(xmlObj3);
	}
	fixedCouponDayFlag.selectedIndex = 0;
	//XenosAlert.info("flag1::"+ xml.instrumentPage.fixedDaysCouponFlag);
	if(xml.instrumentPage.fixedDaysCouponFlag == "Y"){
		//XenosAlert.info("flag2::"+ xml.instrumentPage.fixedDaysCouponFlag);
	fixedCouponDayFlag.selectedIndex = getIndexOfLabelValueBean(fixedCouponDaysFlag, "YES");
	//fixedCouponDaysFlagChangeHandler();
	}
	else{
		fixedCouponDayFlag.selectedIndex = 0;
	}
	prevCouponDate.text = xml.instrumentPage.prevCouponDateStr;
	nextCouponDate.text = xml.instrumentPage.nextCouponDateStr;
	fixedCouponDays.text = xml.instrumentPage.fixedCouponDaysStr;
	
	//Investment Bond Category
	investmentBondCategoryList= new ArrayCollection();
	investmentBondCategoryList.addItem({label: " ", value: " "});
	for each(var xmlObj3:Object in xml.instrumentPage.investmentBondCategoryList.item){
		investmentBondCategoryList.addItem(xmlObj3);
	}
	investmentBondCategory.selectedIndex=getIndexOfLabelValueBean(investmentBondCategoryList, xml.instrumentPage.investBondCategory);
	//Euro Yen Bond Flags
	euroYenBondFlagList=new ArrayCollection();
	euroYenBondFlagList.addItem({label: " ", value: " "});
	for each(var xmlObj3:Object in xml.instrumentPage.euroYenBondFlagList.item){
		euroYenBondFlagList.addItem(xmlObj3);
	}
	euroYenBondFlag.selectedIndex =getIndexOfLabelValueBean(euroYenBondFlagList,xml.instrumentPage.euroYenBondFlag);
	
	
	rateTypeValues = new ArrayCollection();
	rateTypeValues.addItem({label: " " , value : " "});
	for each(var xmlObj4:Object in xml.instrumentPage.floatingFixFlagValues.item){
		rateTypeValues.addItem(xmlObj4);
	}
	rateType.selectedIndex = getIndexOfLabelValueBean(rateTypeValues, xml.instrumentPage.floatingFixFlag);
	
//	rateTypeChangeHandler(rateType.selectedIndex.value);
	
	
	floatingBaseRateValues = new ArrayCollection();
	floatingBaseRateValues.addItem({label: " " , value : " "});
	for each(var xmlObj5:Object in xml.instrumentPage.floatingBaseRateValues.item){
		floatingBaseRateValues.addItem(xmlObj5);
	}
	floatingBaseRate.selectedIndex = getIndexOfLabelValueBean(floatingBaseRateValues, xml.instrumentPage.floatingBaseRate);
	
	monthValues=new ArrayCollection();
	monthValues.addItem({label:"",value:""});
	for each(var obj:Object in xml.monthValues.item){
		monthValues.addItem(obj);
	}
	dayValues=new ArrayCollection();
	dayValues.addItem({label:"",value:""});
	for each(var obj1:Object in xml.dayValues.item){
		dayValues.addItem(obj1);
	}
	
	principalPaymentFreqValues = new ArrayCollection();
	principalPaymentFreqValues.addItem({label: " " , value : " "});
	for each(var xmlObj6:Object in xml.instrumentPage.principalPaymentFreqValues.item){
		principalPaymentFreqValues.addItem(xmlObj6);
	}
	principalPaymentFreqStr.selectedIndex = getIndexOfLabelValueBean(principalPaymentFreqValues, xml.instrumentPage.principalPaymentFreqStr);
	
	//have to populate from form
	accrualStartDateSummaryResult=new ArrayCollection();
	if(xml.child("paymentSchedulesWrapper").length()>0) {
	    for each ( var rec:XML in xml.paymentSchedulesWrapper.paymentSchedules) {			    	
 		    accrualStartDateSummaryResult.addItem(rec);
	    }
	}
	couponInfoSummaryResult=new ArrayCollection();
	if(xml.child("couponRatesWrapper").length()>0) {
	    for each ( var rec1:XML in xml.couponRatesWrapper.couponRates) {			    	
 		    couponInfoSummaryResult.addItem(rec1);
	    }
	}
	
	bondTypeChangeHandler(null);	
	rateType.dispatchEvent(new ListEvent(ListEvent.CHANGE));
	fixedCouponDayFlag.dispatchEvent(new ListEvent(ListEvent.CHANGE));
	
}

public function bondTypeChangeHandler(event:ListEvent):void {
	
	var indexVal:String = (this.couponFrequency.selectedItem != null) ? this.couponFrequency.selectedItem.value:"";
	principalPaymentFreqStr.selectedIndex = getIndexOfLabelValueBean(principalPaymentFreqValues, indexVal );
    
	if (this.bondType.selectedItem.label == "COUPON") {
		// Show Coupon Fields
		gridForCouponTypeCoupon.visible = true;
		gridForCouponTypeCoupon.includeInLayout = true;
		ws.visible = true;
		ws.includeInLayout = true;
		ws.opened = true;
		if(this.mode == "amend"){
			dirtyPriceFlagLbl.visible = true;
			dirtyPriceFlag.visible = true;
		}
		changeClassName();
	}else {
		 // Hide Coupon Fields 
		var alertStr:String = checkNonDiscountFields(null);
				 
        // Some bond fields are set which are not allowed in DISCOUNT bond    
        if(!XenosStringUtils.isBlank(alertStr)) { 
        	//Revert Back the Bond Type as COUPON since coupon releated field is present
          this.bondType.selectedIndex =  getIndexOfLabelValueBean(bondTypes, "COUPON" );

        }else{
        	gridForCouponTypeCoupon.visible = false;
			gridForCouponTypeCoupon.includeInLayout = false;
			ws.percentWidth = 100;
			ws.visible = false;
			ws.includeInLayout = false;
			dirtyPriceFlagLbl.visible = false;
			dirtyPriceFlag.visible = false;
        }
		changeClassName();
		
	}

	//Adding Principle Payment Freq hide and show for pay down flag
	hidePrnPaymentFreq(null);
}
public function rateTypeChangeHandler(event:ListEvent):Boolean {
	//replaced changeFixFloat func. in javascript
	 var fixedCouponRateStr:String;
	 var couponRateCount:int;
	 var floatingBaseRateStr:String;
	 var couponResetDate:String;
	if (ComboBox(event.currentTarget).selectedItem.label == "Fixed") {
		couponRateCount = couponInfoSummaryResult.length;
        if(couponRateCount > 0)
        {
            rateType.selectedIndex  = hiddenFloatingFixFlag; 
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.couponrateforfix'));
            return false;
        }
        floatingBaseRateStr = (this.floatingBaseRate.selectedItem != null) ? this.floatingBaseRate.selectedItem.value:"";
        if(!XenosStringUtils.isBlank(floatingBaseRateStr)) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;   
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.floatbaserateforfix'));
            this.floatingBaseRate.setFocus();
            return false;
        }
        
        couponResetDate = this.couponResetDate.text;  
        if(!XenosStringUtils.isBlank(couponResetDate)) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;    
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.couponresetdateforfix'));
            this.couponResetDate.setFocus();
           return false;
            
        }
		fixedCouponRateLbl.visible = true;
		fixedCouponRateLbl.includeInLayout = true;
		fixedCouponRate.visible = true;
		fixedCouponRate.includeInLayout = true;
		
		floatingBaseRateLbl.visible = false;
		floatingBaseRateLbl.includeInLayout = false;
		floatingBaseRate.visible = false;
		floatingBaseRate.includeInLayout = false;
		
		rateFloatcoupon1.visible = false;
		rateFloatcoupon1.includeInLayout = false;
		
		ws5.percentWidth = 0;
		ws.percentWidth = 100;
		ws5.visible = false;
		ws5.includeInLayout = false;
		
		
	}else if (ComboBox(event.currentTarget).selectedItem.label == "Floating") {
		
		 // Check if Fixed coupon rate is entered.
      
        fixedCouponRateStr = this.fixedCouponRate.text;
        if(!XenosStringUtils.isBlank(fixedCouponRateStr)) {
           rateType.selectedIndex   = hiddenFloatingFixFlag;    
           XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.fixrateforfloat'));
           this.fixedCouponRate.setFocus(); 
           return false;
        }    
        
		fixedCouponRateLbl.visible = false;
		fixedCouponRateLbl.includeInLayout = false;
		fixedCouponRate.visible = false;
		fixedCouponRate.includeInLayout = false;
		
		floatingBaseRateLbl.visible = true;
		floatingBaseRateLbl.includeInLayout = true;
		floatingBaseRate.visible = true;
		floatingBaseRate.includeInLayout = true;
		
		rateFloatcoupon1.visible = true;
		rateFloatcoupon1.includeInLayout = true;
		
		ws.percentWidth = 30;
		ws5.percentWidth = 70;
		ws5.visible = true;
		ws5.includeInLayout = true;
		ws5.opened = true;
	}else{
		
		couponRateCount = couponInfoSummaryResult.length;
        if(couponRateCount > 0) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;    
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.couponrateforothers'));
            return false;
        }
       
        fixedCouponRateStr = this.fixedCouponRate.text;
        if(!XenosStringUtils.isBlank(fixedCouponRateStr)) {
           rateType.selectedIndex   = hiddenFloatingFixFlag;    
           XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.fixrateforothers'));
           this.fixedCouponRate.setFocus();
           return false;
        }    
        
        floatingBaseRateStr = (this.floatingBaseRate.selectedItem != null) ? this.floatingBaseRate.selectedItem.value:"";
        if(!XenosStringUtils.isBlank(floatingBaseRateStr)) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;   
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.floatbaserateforothers'));
            this.floatingBaseRate.setFocus();
            return false;
        }
		
		couponResetDate = this.couponResetDate.text;  
        if(!XenosStringUtils.isBlank(couponResetDate)) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;    
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.couponresetdatefornotfloat'));
            this.couponResetDate.setFocus();
           return false;
            
        }
              
		fixedCouponRateLbl.visible = false;
		fixedCouponRateLbl.includeInLayout = true;
		fixedCouponRate.visible = false;
		fixedCouponRate.includeInLayout = true;
		
		floatingBaseRateLbl.visible = false;
		floatingBaseRateLbl.includeInLayout = false;
		floatingBaseRate.visible = false;
		floatingBaseRate.includeInLayout = false;
		
		rateFloatcoupon1.visible = false;
		rateFloatcoupon1.includeInLayout = false;
		
		ws5.percentWidth = 0;
		ws.percentWidth = 100;
		ws5.visible = false;
		ws5.includeInLayout = false;
	
	}
	return true;
}

private function fixedCouponDaysFlagChangeHandler():void{
	if (fixedCouponDayFlag.selectedItem.label == "Yes"){
		prevCouponDatelbl.visible = true;
		prevCouponDatelbl.includeInLayout = true;
		prevCouponDate.visible = true;
		prevCouponDate.includeInLayout = true;
		fixedCouponDaysLbl.visible = true;
		fixedCouponDaysLbl.includeInLayout = true;
		fixedCouponDays.visible = true;
		fixedCouponDays.includeInLayout = true;
		nextCouponDatelbl.visible = true;
		nextCouponDatelbl.includeInLayout = true;
		nextCouponDate.visible = true;
		nextCouponDate.includeInLayout = true;
	}
	else{
		prevCouponDatelbl.visible = false;
		prevCouponDatelbl.includeInLayout = false;
		prevCouponDate.visible = false;
		prevCouponDate.includeInLayout = false;
		fixedCouponDaysLbl.visible = false;
		fixedCouponDaysLbl.includeInLayout = false;
		fixedCouponDays.visible = false;
		fixedCouponDays.includeInLayout = false;
		nextCouponDatelbl.visible = false;
		nextCouponDatelbl.includeInLayout = false;
		nextCouponDate.visible = false;
		nextCouponDate.includeInLayout = false;
		prevCouponDate.selectedDate = null;
		nextCouponDate.selectedDate = null;
		fixedCouponDays.text = null;
	}
}

private function populateNextCouponDateIfNull():void{	
	if(nextCouponDate.selectedDate == null){
		if(!(XenosStringUtils.isBlank(fixedCouponDays.text) || XenosStringUtils.isBlank(prevCouponDate.text))){
			populateNextCpDate();
		}	
	}
}

private function populateNextCpDateFixedCpDays():void{
	if(!XenosStringUtils.isBlank(fixedCouponDays.text)){
		numVal4.source = fixedCouponDays;
		if(numVal4.handleNumericField(numberFormatter)){
			if(!XenosStringUtils.isBlank(prevCouponDate.text) && XenosStringUtils.isBlank(nextCouponDate.text)){
				populateNextCpDate();
			}
		}
	}
}

private function populateNextCpDatePrevCpDays():void{	 
	if(!XenosStringUtils.isBlank(prevCouponDate.text)){
		if(DateUtils.isValidDate(StringUtil.trim(prevCouponDate.text))){
			if(!XenosStringUtils.isBlank(fixedCouponDays.text) && XenosStringUtils.isBlank(nextCouponDate.text)){
				populateNextCpDate();
			}
		}else{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.error.invalid.previousdate'));
		}
	}
}

private function populateNextCpDate():void{
	 var dateformat:CustomDateFormatter = new CustomDateFormatter();
	 dateformat.formatString="YYYYMMDD";
	 var previousCouponDate:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(prevCouponDate.text));
	 var nextCouponDateCalculated:Date = new Date(previousCouponDate.getTime() + (Number(fixedCouponDays.text) * millisecondsPerDay));
	 nextCouponDate.selectedDate = nextCouponDateCalculated;
}

private function monthValueChanged(e:Event):void{
	var selectedMonth:String=paymentMonth.selectedItem['value'].toString();
	if(!XenosStringUtils.isBlank(selectedMonth)){
		var i:int;
		dayValues=new ArrayCollection();
		dayValues.addItem({label:"",value:""});
		for(i=1;i<=noOfDaysinMonth[selectedMonth];i++){
			dayValues.addItem({label:i,value:i});
		}
	}	
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
 * To add Accrual Information
 */
private function addAccrualInfo():void{
	 addAccrualInfoService.request = populateAccrualInfo();
	 if(this.mode == "amend" && addAccrualInfoService.request != null){
		addAccrualInfoService.url = "ref/instrumentAmendDispatch.action?method=addPaymentSchedule"
		addAccrualInfoService.send();
		}
			//XenosAlert.info(addAccrualInfoService.request.toString());
	else if(addAccrualInfoService.request != null){
		addAccrualInfoService.url = "ref/instrumentEntryDispatch.action?method=addPaymentSchedule"
		addAccrualInfoService.send();
	}
	
	
}

public function editAccrualInfo(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = accrualStartDateSummaryResult.getItemIndex(data);
	accrualStartDateSummaryResult.removeItemAt(reqObj.rowNo);
	
	accrualStartDateSummaryResult.refresh();
	 if(this.mode == "amend")
		editAccrualInfoService.url = "ref/instrumentAmendDispatch.action?method=editPaymentSchedule"
	else 
		editAccrualInfoService.url = "ref/instrumentEntryDispatch.action?method=editPaymentSchedule"
	editAccrualInfoService.request = reqObj;
	editAccrualInfoService.send();
}

 public function deleteAccrualInfo(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = accrualStartDateSummaryResult.getItemIndex(data);
	 if(this.mode == "amend")
		deleteAccrualInfoService.url = "ref/instrumentAmendDispatch.action?method=deletePaymentSchedule"
	else 
		deleteAccrualInfoService.url = "ref/instrumentEntryDispatch.action?method=deletePaymentSchedule"
	deleteAccrualInfoService.request = reqObj;
	deleteAccrualInfoService.send();
}


/**
* This method works as the result handler of the Submit Query Http Services for Memos.
* 
*/
public function AccrualInfoResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		 if(rs.child("paymentSchedulesWrapper").length()>0) {
		 	
			errPage.clearError(event);
			// if(this.mode != "AMEND")
            	accrualStartDateSummaryResult.removeAll(); 
			try {
			    for each ( var rec:XML in rs.paymentSchedulesWrapper.paymentSchedules ) {
			    	rec.isVisible = true;
 				    accrualStartDateSummaryResult.addItem(rec);
			    }
			    paymentMonth.selectedIndex=0;
			    paymentDay.selectedIndex=0;
			   
            	accrualStartDateSummaryResult.refresh();
            	
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
		 	accrualStartDateSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
    
}

/**
* This method works as the result handler of the Submit Query Http Services for Memos.
* 
*/
public function AccrualInfoEditResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);
	var i:int;
	if (null != event) { 
		if(rs.child("paymentSchedulesWrapper").length()>0){
					
			for each ( var rec:XML in rs.paymentSchedulesWrapper.paymentSchedules ) {
			    	rec.isVisible = true;
 				    accrualStartDateSummaryResult.addItem(rec);
			    }
		  
           	accrualStartDateSummaryResult.refresh();
           	
			paymentMonth.selectedIndex=int(new Number(rs.paymentMonth.toString()));	
			monthValueChanged(null);
			paymentDay.selectedIndex=int(new Number(rs.paymentDay.toString()));
			
		} else if(rs.child("Errors").length()>0) {
            //some error found
		 	accrualStartDateSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	accrualStartDateSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
}

private function populateAccrualInfo():Object{
	
	var selectedMonth:String;
	var reqObj : Object = populateRequest() ;//new Object();
	
	
	selectedMonth = reqObj['paymentMonth'] = this.paymentMonth.selectedItem != null ? this.paymentMonth.selectedItem.value : "";
	
	reqObj['paymentDay'] = this.paymentDay.selectedItem != null ? this.paymentDay.selectedItem.value : "";
	//do all validations
	var paymentScheduleCount:int = accrualStartDateSummaryResult.length;
    var couponPaymentFreq:int = (this.couponFrequency.selectedItem != null)? (couponFrequency.selectedItem.value):0; 
   
	var bondType:String = StringUtil.trim(bondType.selectedItem.value);
		
		if(bondType == 'COUPON'){
	
	        if(couponPaymentFreq > 0)
	        {
	           
	            if(paymentScheduleCount >= couponPaymentFreq)
	            {
	                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.count.more.payschedule'));
	                return null;
	            }
	            
	        }
	        else
	        {
	            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.invalid.order.payfreq', new Array(couponPaymentFreq, couponPaymentFreq)));
	            return null;
	        }
		}
		
	if(XenosStringUtils.isBlank(reqObj['paymentMonth']) ){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.paymentmonth'));
		return null;
	}
	/*
	else if(XenosStringUtils.isBlank(reqObj['paymentDay']))
	{
		var errMsg:String="Payment Day not entered.\nNULL Settling Day means last day of ";
		paymentDay.selectedIndex = noOfDaysinMonth[selectedMonth];
		reqObj['paymentDay']=paymentDay.selectedItem['value'].toString();
		
		var dateObj:Date=new Date();
		dateObj.setMonth(Math.abs(Number(selectedMonth) - 1),1);
		var dfmt:DateFormatter=new DateFormatter();
		dfmt.formatString="MMMM";		
		errMsg+=dfmt.format(dateObj)+" "+reqObj['paymentMonth']+"/"+reqObj['paymentDay'];
		XenosAlert.error(errMsg);
		//return null;
	}
	*/
	return reqObj;
	 
	
	
}

/**
 * To add Coupon Rate Information
 */
private function addCouponRateInfo():void{
	addCouponInfoService.request = populateCouponRateInfo();
	 if(this.mode == "amend"){
		addCouponInfoService.url = "ref/instrumentAmendDispatch.action?method=addCouponRate";
	 } else if(addCouponInfoService.request != null){
		addCouponInfoService.url = "ref/instrumentEntryDispatch.action?method=addCouponRate";
	 }
	 addCouponInfoService.send();
}

public function editCouponRateInfo(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = couponInfoSummaryResult.getItemIndex(data);
	couponInfoSummaryResult.removeItemAt(reqObj.rowNo);
	//data.isVisible=false;
	couponInfoSummaryResult.refresh();
	if(this.mode == "amend")
		editCouponInfoService.url = "ref/instrumentAmendDispatch.action?method=editCouponRate"
	else 
		editCouponInfoService.url = "ref/instrumentEntryDispatch.action?method=editCouponRate"
	editCouponInfoService.request = reqObj;
	editCouponInfoService.send();
}

 public function deleteCouponRateInfo(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = couponInfoSummaryResult.getItemIndex(data);
	 if(this.mode == "amend")
		deleteCouponInfoService.url = "ref/instrumentAmendDispatch.action?method=deleteCouponRate"
	else 
		deleteCouponInfoService.url = "ref/instrumentEntryDispatch.action?method=deleteCouponRate"
	deleteCouponInfoService.request = reqObj;
	deleteCouponInfoService.send();
}


/**
* This method works as the result handler of the Submit Query Http Services for coupon add.
* 
*/
public function CouponInfoResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		 if(rs.child("couponRatesWrapper").length()>0) {
		 	
			errPage.clearError(event);
			// if(this.mode != "AMEND")
            	couponInfoSummaryResult.removeAll(); 
			try {
			    for each ( var rec:XML in rs.couponRatesWrapper.couponRates ) {
			    	rec.isVisible = true;
 				    couponInfoSummaryResult.addItem(rec);
 				    trace(XML(rec).toXMLString());
			    }
			    			   
            	couponInfoSummaryResult.refresh();
            	effStartDate.text = "";
				recordDate.text = "";
				rate.text = "";
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
		 	couponInfoSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
    
}

/**
* This method works as the result handler of the Submit Query Http Services for coupon edit.
* 
*/
public function CouponInfoEditResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		if(rs.child("couponRatesWrapper").length()>0){
						
			effStartDate.text=rs.effStartDate.toString();
			recordDate.text=rs.recordDate.toString();
			rate.text=rs.rate.toString();
			
			
		} else if(rs.child("Errors").length()>0) {
            //some error found
		 	couponInfoSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	couponInfoSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
}

private function populateCouponRateInfo():Object{
	
	var reqObj : Object = populateRequest();	
	
	reqObj['dateFrom'] = this.effStartDate.text != null ? this.effStartDate.text : "";
	
	reqObj['recordDate'] = this.recordDate.text != null ? this.recordDate.text : "";
	
	reqObj['rate'] = this.rate.text != null ? this.rate.text : "";
	
	 if(XenosStringUtils.isBlank(this.effStartDate.text)) {// == null || this.effStartDate.text == ''
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.effectstartdate'));
            this.effStartDate.setFocus();
            return null;
        }

        if(XenosStringUtils.isBlank(this.rate.text)) {// == null || this.rate.text == ''
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.couponrate'));
            this.rate.setFocus();
            return null;
        }
        
	return reqObj;
}

override public function  validate():ValidationResultEvent{	
	var bondTypeStr:String = (this.bondType.selectedItem != null) ? StringUtil.trim(this.bondType.selectedItem.value) : "";
	var model:Object;
	var validator:InstrumentBondDetailValidator = new InstrumentBondDetailValidator();
	
		if(bondTypeStr == 'COUPON'){ 
			model = {	bond:{
								bondType:bondTypeStr,
	                    		issuePrice:this.issuePrice.text,
	                    		redmpnCcy:this.redmpnCcy.ccyText.text,
	                    		redmpnPrice:this.redmpnPrice.text,
	                    		issueDate:this.issueDate.text,
	                    		maturityDate:this.maturityDate.text
	                		}
		                	}; 
		                	/*,
	                    		delayDays:this.delayDays.text,
	                    		pdFlag:(this.pdFlag.selectedItem != null) ? this.pdFlag.selectedItem.value : "",
	                    		tipsFlag:(this.tipsFlag.selectedItem != null) ? this.tipsFlag.selectedItem.value : "",
	                    		tipsBase:(this.tipsBase.selectedItem != null) ? this.tipsBase.selectedItem.value : "",
	                    		stripType:(this.stripType.selectedItem != null) ? this.stripType.selectedItem.value : "",
	                    		recordDays:this.recordDays.text,
	                    		couponFrequency:(this.couponFrequency.selectedItem != null) ? this.couponFrequency.selectedItem.value : "",
	                    		couponCcy:this.couponCcy.ccyText.text,
	                    		accIntStartDate:this.accIntStartDate.text,
	                    		accIntCalType:(this.accIntCalType.selectedItem != null) ? this.accIntCalType.selectedLabel : "",
	                    		initialCouponDate:this.initialCouponDate.text,
	                    		initialCouponType:(this.initialCouponType.selectedItem != null) ? this.initialCouponType.selectedItem.value : "",
	                    		finalCouponType:(this.finalCouponType.selectedItem != null) ? this.finalCouponType.selectedItem.value:"",
	                    		rateType:(this.rateType.selectedItem != null) ? this.rateType.selectedItem.value:"",
	                    		fixedCouponRate:this.fixedCouponRate.text,
	                    		floatingBaseRate:(this.floatingBaseRate.selectedItem != null) ? this.floatingBaseRate.selectedItem.value:"",
	                    		couponResetDate:this.couponResetDate.text*/
		                	
		    validator.property = "bond";
		    checkCouponOnlyFields(validator);
		}else {//if(bondTypeStr == 'DISCOUNT') or null
			model = {	bond2:{
								bondType:bondTypeStr,
	                    		issuePrice:this.issuePrice.text,
	                    		redmpnCcy:this.redmpnCcy.ccyText.text,
	                    		redmpnPrice:this.redmpnPrice.text,
	                    		issueDate:this.issueDate.text,
	                    		maturityDate:this.maturityDate.text
	                		}
		                	}; /*,
	                    		delayDays:this.delayDays.text,
	                    		pdFlag:(this.pdFlag.selectedItem != null) ? this.pdFlag.selectedItem.value : "",
	                    		tipsFlag:(this.tipsFlag.selectedItem != null) ? this.tipsFlag.selectedItem.value : "",
	                    		tipsBase:(this.tipsBase.selectedItem != null) ? this.tipsBase.selectedItem.value : "",
	                    		stripType:(this.stripType.selectedItem != null) ? this.stripType.selectedItem.value : "",
	                    		recordDays:this.recordDays.text*/
		  
		   validator.property = "bond2";
		   checkNonDiscountFields(validator);	
		}
		
		validator.source = model;

		var validationResult:ValidationResultEvent = validator.validate(); 
		
		return validationResult;    	
}

private function checkNonDiscountFields(validator:InstrumentBondDetailValidator = null):String
{
	var alertStr:String = "";
	var couponFrequency:String = (this.couponFrequency.selectedItem != null) ? this.couponFrequency.selectedItem.value : "";
    if(!XenosStringUtils.isBlank(couponFrequency) ){
		
		
		 if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"couponFrequency", "couponFrequency", "Cannot enter Coupon Payment Frequency for Bond Type other than COUPON."));
		 }else{
		 	 alertStr += "Cannot enter Coupon Payment Frequency for Bond Type other than COUPON\n";
		 }
	} 
	
	if(!XenosStringUtils.isBlank(this.couponCcy.ccyText.text) ){
		if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"couponCcy", "couponCcy", "Cannot enter Coupon Currency for Bond Type other than COUPON."));
		 }else{
			alertStr += "Cannot enter Coupon Currency for Bond Type other than COUPON\n";
		 }
	} 
	
	if(!XenosStringUtils.isBlank(this.accIntStartDate.text) ){
		 if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"accIntStartDate", "accIntStartDate", "Cannot enter Accrued Interest Init Date for Bond Type other than COUPON."));
		 }else{
			 alertStr += "Cannot enter Accrued Interest Init Date for Bond Type other than COUPON\n";
		 }
	}  
	
	var accIntCalType:String = (this.accIntCalType.selectedItem != null) ? this.accIntCalType.selectedLabel : "";
	
	if(!XenosStringUtils.isBlank(accIntCalType) ){
		if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"accIntCalType", "accIntCalType", "Cannot enter Accrued Interest Calculation Type for Bond Type other than COUPON."));
		 }else{
			alertStr += "Cannot enter Accrued Interest Calculation Type for Bond Type other than COUPON\n";
		 }
	}  
    
    var rateType:String = (this.rateType.selectedItem != null) ? this.rateType.selectedItem.value : "";
    if(!XenosStringUtils.isBlank(rateType) ){
		if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"rateType", "rateType", "Cannot enter Rate Type for Bond Type other than COUPON."));
		 }else{
			alertStr += "Cannot enter Rate Type for Bond Type other than COUPON\n";
		 }
	}
	
    var initialCouponType:String = (this.initialCouponType.selectedItem != null) ? this.initialCouponType.selectedItem.value : "";
    if(!XenosStringUtils.isBlank(initialCouponType) ){
		if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"initialCouponType", "initialCouponType", "Cannot enter Initial Coupon Type for Bond Type other than COUPON."));
		 }else{
			alertStr += "Cannot enter Initial Coupon Type for Bond Type other than COUPON\n";
		 }
	}
	
	if(!XenosStringUtils.isBlank(this.initialCouponDate.text) ){
		if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"initialCouponDate", "initialCouponDate", "Cannot enter Initial Coupon Date for Bond Type other than COUPON."));
		 }else{
			alertStr += "Cannot enter Initial Coupon Date for Bond Type other than COUPON\n";
		 }
	}
	
	 var finalCouponType:String = (this.finalCouponType.selectedItem != null) ? this.finalCouponType.selectedItem.value : "";
	if(!XenosStringUtils.isBlank(finalCouponType) ){
		 if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"finalCouponType", "finalCouponType", "Cannot enter Final Coupon Type for Bond Type other than COUPON."));
		 }else{
			 alertStr += "Cannot enter Final Coupon Type for Bond Type other than COUPON\n";
		 }
	}
	
  

    var flag:String = (this.pdFlag.selectedItem != null)? this.pdFlag.selectedItem.value: "" ;
   	var principlePayFreq:String = (this.principalPaymentFreqStr.selectedItem != null)? this.principalPaymentFreqStr.selectedItem.value: "";
    if( flag == "Y" && (XenosStringUtils.isBlank(principlePayFreq)) ) {
        if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"principalpaymentfreq", "principalpaymentfreq", "Principal Payment Freq is empty."));
		 }else{
        	alertStr += "Principal Payment Freq is empty\n";
         }
	}

    if(validator == null && alertStr != ""){
   	 XenosAlert.error(alertStr);
   	 return 'error';
    }else{
     return '';
    }
    
}

private function validateNumber(event:FocusEvent):void{
	numVal1.source = TextInput(event.currentTarget);
	numVal1.handleNumericField(numberFormatter);
}

private function validateNumber2(event:FocusEvent):void{
	numVal2.source = TextInput(event.currentTarget);
	numVal2.handleNumericField(numberFormatter);
}

private function validateNumber3(event:FocusEvent):void{
	numVal3.source = TextInput(event.currentTarget);
	numVal3.handleNumericField(numberFormatter);
}

/*private function validateNumber4(event:FocusEvent):void{
	numVal4.source = TextInput(event.currentTarget);
	numVal4.handleNumericField(numberFormatter);
}*/

private function validateNumber5(event:FocusEvent):void{
	numVal5.source = TextInput(event.currentTarget);
	numVal5.handleNumericField(numberFormatter);
}

/**
 * This method blocks the visualization of the Principle Payment Freq when Pay Down Flag 'No' is selected 
 * in Instrument Bond Entry Page.
 */
private function hidePrnPaymentFreq(event:ListEvent):void
{
	var flag:String = (this.pdFlag.selectedItem != null) ? this.pdFlag.selectedItem.value: "" ;
   	var principlePayFreq:String = (this.principalPaymentFreqStr.selectedItem) ? this.principalPaymentFreqStr.selectedItem.value : "";
   	var bondTypeStr:String = StringUtil.trim(this.bondType.selectedItem.value);
   	var alertStr:String = '';
   	 
    if( flag != "Y" && bondTypeStr == "DISCOUNT" && (!XenosStringUtils.isBlank(principlePayFreq))) {
    	alertStr += "Cannot change Pay Down Flag to N or blank if Payment Schedule is present or Principal Payment Freq is present\n";
    	this.pdFlag.selectedIndex = getIndexOfLabelValueBean(pdFlagValues, "Y");
    }
	
	if(flag == "Y" && bondTypeStr == "DISCOUNT") {
		principalPaymentFreqStrLbl.includeInLayout = true;
		principalPaymentFreqStrLbl.visible = true;
		principalPaymentFreqStrLbl.styleName = "ReqdLabel";
		principalPaymentFreqStr.includeInLayout = true;
		principalPaymentFreqStr.visible = true;
		principalPaymentFreqStr.enabled = true;
	} 
	if(flag == "Y" && bondTypeStr == "COUPON") {
		principalPaymentFreqStrLbl.includeInLayout = true;
		principalPaymentFreqStrLbl.visible = true;
		principalPaymentFreqStrLbl.styleName = "ReqdLabel";
		principalPaymentFreqStr.includeInLayout = true;
		principalPaymentFreqStr.visible = true;
		principalPaymentFreqStr.enabled = false;
	}
	if(flag == "Y" && bondTypeStr == "DISCOUNT") {
		ws.includeInLayout = true;
		ws.visible = true;
		ws.opened = true;
	}
	if(flag == "Y" && bondTypeStr == "") {
    	ws.includeInLayout = false;
		ws.visible = false;
	}
	if(flag == "N" || flag == " ") {
		principalPaymentFreqStrLbl.includeInLayout = false;
		principalPaymentFreqStrLbl.visible = false;
		principalPaymentFreqStr.includeInLayout = false;
		principalPaymentFreqStr.visible = false;
		principalPaymentFreqStr.enabled = false;
	}
	if((flag == "N" || flag == " ") && bondTypeStr == "DISCOUNT") {
    	ws.includeInLayout = false;
		ws.visible = false;
    	
	}
}
/**
 * Check the existence of the fields which are mandatory for COUPON bond.
 * If any field doesn't have any value populate the alert string and return it.
 */
private function checkCouponOnlyFields(validator:InstrumentBondDetailValidator = null):void
{
    var alertStr:String = '';
    var rateType:String =(this.rateType.selectedItem != null) ? this.rateType.selectedItem.value : "";
	
    if(!XenosStringUtils.isBlank(rateType)) {
        if(rateType == 'FIX')
        {
        	var floatingBaseRate:String = (this.floatingBaseRate.selectedItem != null) ? this.floatingBaseRate.selectedItem.value :"";
            if(!XenosStringUtils.isBlank(floatingBaseRate))
            {
               if(validator != null){
		 			validator.results.push(new ValidationResult(true, 
                    	"floatingBaseRate", "floatingBaseRate", "Cannot enter Floating Base Rate for Rate Type FIX."));
		 		}else{
                	alertStr += "Cannot enter Floating Base Rate for Rate Type FIX\n";
     			}
               
            }
            
            if(XenosStringUtils.isBlank(this.fixedCouponRate.text))
            {
               if(validator != null){
		 			validator.results.push(new ValidationResult(true, 
                    	"fixedCouponRate", "fixedCouponRate", "Please enter Fixed Coupon Rate for Rate Type FIX."));
		 		}else{
               		 alertStr += "Please enter Fixed Coupon Rate for Rate Type FIX\n";
   				}
               
            }
        }
        else if(rateType == 'FLOAT')
        {
           
        }
    }

    var flag:String = (this.pdFlag.selectedItem != null)? this.pdFlag.selectedItem.value: "" ;
   	var principlePayFreq:String = (this.principalPaymentFreqStr.selectedItem != null) ? this.principalPaymentFreqStr.selectedItem.value : "";
    if( flag != "Y"  && (!XenosStringUtils.isBlank(principlePayFreq)) ) {
        principalPaymentFreqStr.selectedIndex = getIndexOfLabelValueBean(principalPaymentFreqValues, null );
	}

    if( flag == "Y" && (XenosStringUtils.isBlank(principlePayFreq)) ) {
        var cp:String = ( this.couponFrequency.selectedItem != null) ? this.couponFrequency.selectedItem.value:"";
        principalPaymentFreqStr.selectedIndex = getIndexOfLabelValueBean(principalPaymentFreqValues,  cp);
       
    }

    if(validator == null){
   	 XenosAlert.error(alertStr);
    }
}
/**
 * This method hides input fields for COUPON bond if the bond type is not 'COUPON'.
 */
private function hideCouponFields():void
{
	//replaced by bondTypeChangeHandler
}

/**
 * This function validates the no. of Payment Schedule entered based on the 
 * Coupon Payment Frequency in Bond Page 
 */
private function validatePaymentSchedule(event:ListEvent):Boolean {

    var coupnFreqncy:int = (this.couponFrequency.selectedItem != null) ?  this.couponFrequency.selectedItem.value : 0;
	var flag:String = (this.pdFlag.selectedItem != null) ? this.pdFlag.selectedItem.value : "";
	
	var paymentScheduleCount:int = accrualStartDateSummaryResult.length;
   
    var couponFqncy:String = (this.couponFrequency.selectedItem != null) ? this.couponFrequency.selectedItem.value : "";
    if(XenosStringUtils.isBlank(couponFqncy)) {
        
        if(paymentScheduleCount > 0) {
           couponFrequency.selectedIndex = hiddenCouponPaymentFreq; 
           XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.payscheduleforfreq'));
           return false;
        }
    }
    else if(coupnFreqncy < paymentScheduleCount) {
        couponFrequency.selectedIndex = hiddenCouponPaymentFreq; 
        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.count.payscheduleforfreq'));
        return false;
    }

	
    if(flag == "Y") {
	    principalPaymentFreqStr.selectedIndex = getIndexOfLabelValueBean(principalPaymentFreqValues, String(coupnFreqncy) );
    } else {
        principalPaymentFreqStr.selectedIndex = getIndexOfLabelValueBean(principalPaymentFreqValues, " ");
    }
	/*if (this.couponFrequency.selectedIndex == 0)
	{
		principalPaymentFreqStr.selectedIndex = getIndexOfLabelValueBean(principalPaymentFreqValues, " ");
	}*/
	return true;
}
/**
* Stores the current value of the couponPaymentFreq field such that if 
* a validation error occurs the user previous value will be selected.
*/
private function storeCurrentCouponFreqValue(event:FocusEvent):void {

   
   hiddenCouponPaymentFreq = ComboBox(event.currentTarget).selectedIndex;//this.couponFrequency.selectedIndex;
}
// Function for Changing Color of Labels to Mandetory RED for discountCouponType = 'COUPON'
private function changeClassName():void {
	var bondTypeStr:String = StringUtil.trim(this.bondType.selectedItem.value);
	if (bondTypeStr == 'COUPON')
	{
		issueDateLbl.styleName = "ReqdLabel";
		maturityDateLbl.styleName = "ReqdLabel";
		redmpnCcyLbl.styleName = "ReqdLabel";

	}else if (bondTypeStr == 'DISCOUNT'){
		// 
		issueDateLbl.styleName = "";
		maturityDateLbl.styleName = "";
		redmpnCcyLbl.styleName = "ReqdLabel";
			
	}else{
		// 
		issueDateLbl.styleName = "";
		maturityDateLbl.styleName = "";
		redmpnCcyLbl.styleName = "";
	}
}

/**
* Stores the current value of the discountCouponType field such that if 
* a validation error occurs the user previous value will be selected.
*/
private function storeCurrentCouponValue(event:FocusEvent):void {

   
   hiddenDiscountCouponType = bondType.selectedIndex;
}

/**
* Stores the current value of the floatingFixFlag field such that if 
* a validation error occurs the user previous value will be selected.
*/
private function storeCurrentRateTypeValue(event:FocusEvent):void {
   hiddenFloatingFixFlag = this.rateType.selectedIndex;
}

/*private function storeCurrentFixedCpFlagValue(event:FocusEvent):void {
   hiddentFixedCpFlag = this.fixedCouponDayFlag.selectedIndex;
}*/
