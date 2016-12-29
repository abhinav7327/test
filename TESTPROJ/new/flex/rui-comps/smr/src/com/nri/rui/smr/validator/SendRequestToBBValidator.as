
package com.nri.rui.smr.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosStringUtils;
		
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

    public class SendRequestToBBValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results : Array;
        
        public function SendRequestToBBValidator()
        {
            //TODO: implement function
            super();
        }
        /**
         * validate entitlement query form
         */ 
        protected override function doValidation(value : Object) : Array
        {
        	if (value == null) {
                XenosAlert.info("Nothing to validate");
                return null;
            }
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                 
            // Return if there are errors.
            if (results.length > 0)
                return results;
            
            var ticker:String = value.ticker;
            var securityCodeType:String = value.secCodeType;
            var securityCode:String = value.secCode;
            var securityType:String = value.secType;
            
			if (XenosStringUtils.isBlank(ticker)) {
	          	if (XenosStringUtils.isBlank(securityCodeType) ||
	          		XenosStringUtils.isBlank(securityCode)) {
					results.push(new ValidationResult(true, 
							"secCode", "blankSecCode", 
							Application.application.xResourceManager.getKeyValue('smr.error.blank.secCode')));            				
	          			
	          	}
			}  else {
	          	if (!XenosStringUtils.isBlank(securityCodeType) ||
	          		!XenosStringUtils.isBlank(securityCode)) {
					results.push(new ValidationResult(true, 
							"secCode", "blankSecCode", 
							Application.application.xResourceManager.getKeyValue('smr.error.blank.secCode')));            				
	          			
	          	}				
			}
			
            if(XenosStringUtils.isBlank(securityType)){
                results.push(new ValidationResult(true, 
		        		"securityType", "blankSecurityType", 
		                Application.application.xResourceManager.getKeyValue('smr.error.blank.bbProductKey')));
            }
                        
            return results;
        }
    }
}