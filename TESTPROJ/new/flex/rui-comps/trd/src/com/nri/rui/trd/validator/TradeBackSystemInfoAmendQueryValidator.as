// ActionScript file


 
 package com.nri.rui.trd.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    
    /**
     * Custom Validator for Trade Back System Info Amend Query Implementation.
     * 
     */   
	public class TradeBackSystemInfoAmendQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function TradeBackSystemInfoAmendQueryValidator() {
            super();
        }
               
        /**
         * 
         * validate Trade Back System Info Amend Query
         */ 
       
        protected override function doValidation(value:Object):Array {
            if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('trd.value.obj.null'));
                return null;
            }
            
            var dateList:Array = [];
            
        	var trdDateFrom:String =value.trddateFrom;
        	if(trdDateFrom != "")
        		dateList.push(trdDateFrom);
            var trdDateTo:String =value.trddateTo;
            if(trdDateTo != "")
            	dateList.push(trdDateTo);
            var valueDateFrom:String =value.valuedateFrom;
            if(valueDateFrom != "")
            	dateList.push(valueDateFrom);
            var valueDateTo:String=value.valuedateTo;
            if(valueDateTo != "")
            	dateList.push(valueDateTo);
            
            var flag:int=0;
            
            // Clear results Array.
            results = [];

			var formatData:String = XenosStringUtils.EMPTY_STR;
			var dateformat:CustomDateFormatter = new CustomDateFormatter();
            // Call base class's doValidation().
            results = super.doValidation(value);
                 
            // Return if there are errors.
            if (results.length > 0)
                return results;
            
            var tdFrom:Date = null;
            var tdTo:Date = null;
            var vdFrom:Date = null;
            var vdTo:Date = null;
            var comDate:int = 0;
        	if(value.trddateFrom != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.trddateFrom));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.trddateFrom))) {
	                
	                results.push(new ValidationResult(true, 
	                    "tradeDateFrom", "illegalTradeDateFrom", Application.application.xResourceManager.getKeyValue('trd.invalid.tradedate.from')  + value.trddateFrom));
	            }else{
	            	tdFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.trddateFrom));
	            }
        	}
        	
        	if(value.trddateTo != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.trddateTo));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.trddateTo))) {
	                results.push(new ValidationResult(true, 
	                    "tradeDateTo", "illegalTradeDateTo", Application.application.xResourceManager.getKeyValue('trd.invalid.tradedate.to')  + value.trddateTo));
	            }else{
	            	tdTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.trddateTo));
	            }
        	}
        	
        	if(tdTo != null && tdFrom != null){
        		if(ObjectUtil.dateCompare(tdFrom,tdTo) == 1){
	        		results.push(new ValidationResult(true, 
	                    "", "tradeDateFromLessThanTradeDateTo",  Application.application.xResourceManager.getKeyValue('trd.error.datecompare.tradedate.tofrom')));
	        	}
        	}
        	
        	if(value.valuedateFrom != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valuedateFrom));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valuedateFrom))) {
	                
	                results.push(new ValidationResult(true, 
	                    "valueDateFrom", "illegalValueDateFrom", Application.application.xResourceManager.getKeyValue('trd.invalid.valuedate.from')  + value.valuedateFrom));
	            }else{
	            	vdFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.valuedateFrom));
	            }
        	}
        	
        	if(value.valuedateTo != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valuedateTo));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valuedateTo))) {
	                results.push(new ValidationResult(true, 
	                    "valueDateTo", "illegalValueDateTo", Application.application.xResourceManager.getKeyValue('trd.invalid.valuedate.to')  + value.valuedateTo));
	            }else{
	            	vdTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.valuedateTo));
	            }
        	}
        	
        	if(vdTo != null && vdFrom != null){
        		if(ObjectUtil.dateCompare(vdFrom,vdTo) == 1){
	        		results.push(new ValidationResult(true, 
	                    "", "valueDateFromLessThanValueDateTo",  Application.application.xResourceManager.getKeyValue('trd.error.datecompare.valuedate.tofrom')));
	        	}
        	}
        	return results;
        }
	}
}