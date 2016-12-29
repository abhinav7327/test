// ActionScript file


package com.nri.rui.slr.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    
    /**
     * Custom Validator for Banking Trade Entry Implementation.
     * 
     */
	public class SlrEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function SlrEntryValidator() {
			super();
		}
		
		/**
         * validate slr trade entry form
         */ 
        protected override function doValidation(value:Object):Array {
        	
        	// Clear results Array.
            results = [];
            var formatData:String ="";
            var dateformat:CustomDateFormatter = new CustomDateFormatter();

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;

        	if(!XenosStringUtils.isBlank(value.tradeDate)){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString = "YYYYMMDD";
	            formatData = "";	            
	            formatData = dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.tradeDate))) {
	                results.push(new ValidationResult(true, 
	                    "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('slr.validation.error.illegaltrddateformat') + value.tradeDate));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "tradeDate", "tradeDateMissing", Application.application.xResourceManager.getKeyValue('slr.validation.error.trddatemissing')));
        	}
        	
        	if(!XenosStringUtils.isBlank(value.startDate)){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.startDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.startDate))) {
	                results.push(new ValidationResult(true, 
	                    "startDate", "illegalStartDate", Application.application.xResourceManager.getKeyValue('slr.validation.error.illegalstartdateformat') + value.startDate));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "startDate", "startDateMissing", Application.application.xResourceManager.getKeyValue('slr.validation.error.startdatemissing')));
        	}
        	
        	if(!XenosStringUtils.isBlank(value.endDate)){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString = "YYYYMMDD";
	            formatData = "";	            
	            formatData = dateformat.format(CustomDateFormatter.customizedInputDateString(value.endDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.endDate))) {
	                results.push(new ValidationResult(true, 
	                    "endDate", "illegalEndDate", Application.application.xResourceManager.getKeyValue('slr.validation.error.illegalenddateformat') + value.endDate));
	            }
        	}
        	
        	if(!XenosStringUtils.isBlank(value.expirationDate)){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString = "YYYYMMDD";
	            formatData = "";	            
	            formatData = dateformat.format(CustomDateFormatter.customizedInputDateString(value.expirationDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.expirationDate))) {
	                results.push(new ValidationResult(true, 
	                    "expirationDate", "illegalExpirationDate", Application.application.xResourceManager.getKeyValue('slr.validation.error.illegalexpirydateformat') + value.expirationDate));
	            }
        	}
        	
        	if(XenosStringUtils.isBlank(value.fundAccNo)){
        		 results.push(new ValidationResult(true, 
	                    "fundAccNo", "fundAccNoMissing", Application.application.xResourceManager.getKeyValue('slr.validation.error.fundaccnomissing')));
        	}
        	
        	if(XenosStringUtils.isBlank(value.brokerAccNo)){
        		 results.push(new ValidationResult(true, 
	                    "brokerAccNo", "brokerAccNoMissing", Application.application.xResourceManager.getKeyValue('slr.validation.error.brokeraccnomissing')));
        	}
        	if(XenosStringUtils.isBlank(value.tradeType)){
        		 results.push(new ValidationResult(true, 
	                    "tradeType", "tradeTypeMissing", Application.application.xResourceManager.getKeyValue('slr.validation.error.trdtypemissing')));
        	}
        	
        	if(XenosStringUtils.isBlank(value.interestRate)){
        		 results.push(new ValidationResult(true, 
	                    "interestRate", "interestRateMissing", Application.application.xResourceManager.getKeyValue('slr.validation.error.intrratemissing')));
        	}
        	
        	if(XenosStringUtils.equals(value.securityListSize,"0")){
        		 results.push(new ValidationResult(true, 
	                    "securityListSize", "securityMissing", Application.application.xResourceManager.getKeyValue('slr.validation.error.enteratlstonesec')));
        	}
        	
        	return results;
        }
		
	}
}