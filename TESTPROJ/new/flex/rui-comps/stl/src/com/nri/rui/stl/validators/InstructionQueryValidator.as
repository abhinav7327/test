
package com.nri.rui.stl.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class InstructionQueryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        
		public function InstructionQueryValidator()
		{
			super();
		}
		/**
         * 
         * validate Completion summary form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
			if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.message.error.objectnull'));
                return null;
            }
            
                    
            var trdDateFrom:String = value.trddateFrom;
            var trddateTo:String = value.trddateTo;
            var valuedateFrom:String = value.valuedateFrom;
            var valuedateTo:String = value.valuedateTo;
            var tradeReferenceNo:String = value.tradeReferenceNo;
            var settleFor:String = value.settleFor;
            var operatiobObj:String = value.operatiobObj;
            var trxDate:String = value.trxDate;
            var inxCreateDate:String = value.inxCreateDate;
            var ccyBox:String = value.ccyBox;
            var stlCcyExclude:Boolean = value.stlCcyExclude;
            var tradeCcyBox:String = value.tradeCcyBox;
            var trdCcyExclude:Boolean = value.trdCcyExclude;
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
            // Check to & Form Date Format.            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            var fromDateObj:Date = null;
            var toDateObj:Date=null;
            
            var inxDateObj:Date = null;
            var trxDateObj:Date = null;
            
            var comDate:int = 0;
            
            if(trdDateFrom!=""){
	            if(DateUtils.isValidDate(trdDateFrom)){
	                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(trdDateFrom));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('stl.message.error.invalidtrdfromdate'))); 
	            }
	         }
            if(trddateTo!=""){
	            if(DateUtils.isValidDate(trddateTo)){
	                toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(trddateTo));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('stl.message.error.invalidtrdtodate'))); 
	            }
            }
            
            if(trxDate!=""){
	            if(DateUtils.isValidDate(trxDate)){
	                trxDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(trxDate));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "trxDate", "invalidtrxDate", Application.application.xResourceManager.getKeyValue('stl.message.error.invalidtrdtrxdate'))); 
	            }
	         }
	         
	         if(inxCreateDate!=""){
	            if(DateUtils.isValidDate(inxCreateDate)){
	                inxDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(inxCreateDate));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "inxCreateDate", "invalidinxCreateDate", Application.application.xResourceManager.getKeyValue('stl.message.error.invalidtrdinxcreateddate'))); 
	            }
	         }
	        // Comparing Trade-Date From and Transmission Date
	        if(fromDateObj!=null && trxDateObj!=null) {
	        	comDate=ObjectUtil.dateCompare(fromDateObj,trxDateObj);
	        } 
	        if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "trxDateLessThanFromDate", Application.application.xResourceManager.getKeyValue('stl.message.error.transmission.date.cannot.be.lesser.than.trade.date')));
            } 
            
            comDate = 0;
            
            // Comparing Trade-Date From and Inx Creation Date
            if(fromDateObj!=null && inxDateObj!=null) {
	        	comDate=ObjectUtil.dateCompare(fromDateObj,inxDateObj);
	        }
	        if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "inxDateLessThanFromDate", Application.application.xResourceManager.getKeyValue('stl.message.error.inx.created.date.cannot.be.lesser.than.trade.date')));
            } 
            
            comDate = 0;
            
            
            if(fromDateObj!=null && toDateObj!=null){
            	comDate=ObjectUtil.dateCompare(fromDateObj,toDateObj);
            	fromDateObj = null;
            	toDateObj = null;
            }
            // check Form Date not less than To Date
            if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('stl.message.error.fromtrddateshouldbelessthantrdtodate')));
            }
            comDate = 0;
            if(valuedateFrom!=""){
	            if(DateUtils.isValidDate(valuedateFrom)){
	                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valuedateFrom));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('stl.message.error.invalidvdfromdate'))); 
	            }
            }
            if(valuedateTo!=""){
	            if(DateUtils.isValidDate(valuedateTo)){
	                toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valuedateTo));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('stl.message.error.invalidvdtodate'))); 
	            }
            }
            if(fromDateObj!=null && toDateObj!=null){
            	comDate=ObjectUtil.dateCompare(fromDateObj,toDateObj);
            }
            // check Form Date not less than To Date
            if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('stl.message.error.fromvddateshouldbelessthanvdtodate')));
            }
            
            if(!XenosStringUtils.isBlank(tradeReferenceNo)){
            	if(XenosStringUtils.isBlank(settleFor)){
            		results.push(new ValidationResult(true, 
                     "", "trdRefNo", Application.application.xResourceManager.getKeyValue('stl.message.error.selectvalidtradefor')));
            	}
            }
            
            if(!XenosStringUtils.isBlank(settleFor)){
            	if(XenosStringUtils.isBlank(tradeReferenceNo)){
            		results.push(new ValidationResult(true, 
                     "", "trdRefNo", Application.application.xResourceManager.getKeyValue('stl.message.error.entervalidtrdrefno')));
            	}
            }
            
            if(stlCcyExclude) {
            	if(XenosStringUtils.isBlank(ccyBox)) {
            		results.push(new ValidationResult(true, 
                     "", "stlCcy", Application.application.xResourceManager.getKeyValue('stl.message.error.stlccyreqdforexclude')));
            	}
            }
            
            if(trdCcyExclude) {
            	if(XenosStringUtils.isBlank(tradeCcyBox)) {
            		results.push(new ValidationResult(true, 
                     "", "trdCcy", Application.application.xResourceManager.getKeyValue('stl.message.error.trdccyreqdforexclude')));
            	}
            }
            
            return results;
        }
	}
}