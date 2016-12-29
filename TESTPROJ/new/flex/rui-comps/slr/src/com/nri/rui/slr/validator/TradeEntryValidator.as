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
     * Custom Validator for borrow/return Trade Entry Implementation.
     * 
     */
	public class TradeEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function TradeEntryValidator() {
			super();
		}
		
		/**
         * validate trade entry form
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
	                    "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('slr.sbr.validation.error.illegaltrddateformat') + value.tradeDate));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "tradeDate", "tradeDateMissing", Application.application.xResourceManager.getKeyValue('slr.sbr.validation.error.trddatemissing')));
        	}
        	
        	if(!XenosStringUtils.isBlank(value.valueDate)){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDate))) {
	                results.push(new ValidationResult(true, 
	                    "valueDate", "illegalStartDate", Application.application.xResourceManager.getKeyValue('slr.sbr.validation.error.illegalvaluedateformat') + value.valueDate));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "valueDate", "startDateMissing", Application.application.xResourceManager.getKeyValue('slr.sbr.validation.error.valuedatemissing')));
        	}
        	
        	
        	
        	if(XenosStringUtils.isBlank(value.fundAccNo)){
        		 results.push(new ValidationResult(true, 
	                    "fundAccNo", "fundAccNoMissing", Application.application.xResourceManager.getKeyValue('slr.sbr.validation.error.fundaccnomissing')));
        	}
        	
        	
        	if(value.securityListSize != null){
        		if(XenosStringUtils.equals(value.securityListSize,"0")){
        		 results.push(new ValidationResult(true, 
	                    "securityListSize", "securityMissing", Application.application.xResourceManager.getKeyValue('slr.sbr.validation.error.enteratlstonesec')));
        		}
        	}
        	
        	if(value.quantity != null){
        		if(XenosStringUtils.isBlank(value.quantity)){
        		 results.push(new ValidationResult(true, 
	                    "quantity", "quantityMissing", Application.application.xResourceManager.getKeyValue('slr.sbr.validation.error.quantitymissing')));
        		}
        	}
        	
        	if(value.secrityCode != null){
        		if(XenosStringUtils.isBlank(value.secrityCode)){
        		 results.push(new ValidationResult(true, 
	                    "secrityCode", "secrityCodeMissing", Application.application.xResourceManager.getKeyValue('slr.sbr.validation.error.seccodemissing')));
        		}
        	}
        	
        	
        	
        	return results;
        }
		
	}
}