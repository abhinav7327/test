// ActionScript file


package com.nri.rui.drv.validators
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */
	public class DrvMarginDetailsValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function DrvMarginDetailsValidator() {
			super();
		}
		
		/**
         * 
         * validate movement query form
         */        
        protected override function doValidation(value:Object):Array {
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
                
            // Validate Security Code    
        	if(value.trdRefNo == null || StringUtil.trim(value.trdRefNo) == ""){
        		 results.push(new ValidationResult(true, 
	                    "trdRefNo", "trdRefNoMissing", Application.application.xResourceManager.getKeyValue('drv.validator.missing.trdref')));
        	}
        	        	       	
        	// Validate Fund Account No
        	if(value.marginType == null || StringUtil.trim(value.marginType) == ""){
        		 results.push(new ValidationResult(true, 
	                    "marginType", "marginTypeMissing", Application.application.xResourceManager.getKeyValue('drv.validator.missing.margintype')));
        	}
        	
        	// Validate Base Date
        	if(value.baseDate == null || StringUtil.trim(value.baseDate) == ""){
        		 results.push(new ValidationResult(true, 
	                    "baseDate", "baseDateMissing", Application.application.xResourceManager.getKeyValue('drv.validator.missing.basedate')));
        	}
        	
        	// Validate Execution Broker Account No
        	if(value.marginAmount == null || StringUtil.trim(value.marginAmount) == ""){
        		 results.push(new ValidationResult(true, 
	                    "marginAmount", "marginAmountMissing",Application.application.xResourceManager.getKeyValue('drv.validator.missing.marginamt')));
        	}                   	
        	
        	return results;
        }
		
	}
}