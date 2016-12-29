// ActionScript file


package com.nri.rui.stl.validators {
	
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */
	public class InxStatusQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function InxStatusQueryValidator() {
			super();
		}
		
		/**
         * 
         * validate bank transfer query form
         */ 
       
        protected override function doValidation(value:Object):Array {
        	
        	
        	
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
        	var dateList:Array = [];
        	var fromDate:Date;
        	var toDate:Date;
        	
        	
        	if(value.tradeDateFrom != null && StringUtil.trim(value.tradeDateFrom).length!=0) {
	            var dateformat:CustomDateFormatter = new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString = "YYYYMMDD";
	            var formatData:String = "";
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDateFrom));
	            if(DateUtils.isValidDate(StringUtil.trim(value.tradeDateFrom))) {
	                fromDate=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.tradeDateFrom));
	            }else{
	            	results.push(new ValidationResult(true, 
	                    "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('stl.error.illegal.date.format') + value.tradeDateFrom));
	                    return results;
	            }
        	}
        	if(value.tradeDateTo != null && StringUtil.trim(value.tradeDateTo).length!=0) {
	            var dateformat:CustomDateFormatter = new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString = "YYYYMMDD";
	            var formatData:String = "";
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDateTo));
	            if(DateUtils.isValidDate(StringUtil.trim(value.tradeDateTo))) {
	                toDate=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.tradeDateTo));
	            }else{
	            	results.push(new ValidationResult(true, 
	                    "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('stl.error.illegal.date.format') + value.tradeDateTo));
	                    return results;
	            }
        	}
        	if(StringUtil.trim(value.tradeDateFrom) != "" && StringUtil.trim(value.tradeDateTo) != ""){
	            	if (ObjectUtil.dateCompare(fromDate,toDate)==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('stl.error.tradedatefrom.mustbe.lessthan.tradedateto')));
	            }
	        }
        	if(value.transmissionDate != null && StringUtil.trim(value.transmissionDate).length!=0) {
	            var dateformat:CustomDateFormatter = new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString = "YYYYMMDD";
	            var formatData:String = "";
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.transmissionDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.transmissionDate))) {
	                results.push(new ValidationResult(true, 
	                    "transmissionDate", "illegalTransmissionDate", Application.application.xResourceManager.getKeyValue('stl.error.illegal.date.format') + value.transmissionDate));
	                    return results;
	            }
        	}
        	return results;
        }
		
	}
}