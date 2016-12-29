
package com.nri.rui.smr.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosStringUtils;
		
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class SecurityRegistrationQueryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results : Array;
        
		public function SecurityRegistrationQueryValidator()
		{
			super();
		}
		
		/**
         * validate entitlement query form
         */ 
        protected override function doValidation(value : Object) : Array
        {
        	if (value == null) {
                XenosAlert.info("value object is null");
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
            var isin:String = value.isin;
            var cusip:String = value.cusip;
            var sedol:String = value.sedol;
            var nam:String = value.nam;
            var name:String = value.name;
                        
            trace("security name: " + name);
            if(XenosStringUtils.isBlank(ticker) && XenosStringUtils.isBlank(isin) &&
            		XenosStringUtils.isBlank(cusip) && XenosStringUtils.isBlank(sedol) &&
            		XenosStringUtils.isBlank(nam) && XenosStringUtils.isBlank(name)) {
            	results.push(new ValidationResult(true, 
		                    "secCode", "blankSecCode", Application.application.xResourceManager.getKeyValue('smr.error.blank.secCode')));
            }
            
            return results;
        }
	}
}