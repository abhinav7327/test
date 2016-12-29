// ActionScript file


package com.nri.rui.stl.validators {
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
	
    /**
     * Custom Validator for WireInstruction Popup Implementation.
     * 
     */
	public class WireInstructionPopupValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;
        private var flag:String;

        // constructor
		public function WireInstructionPopupValidator(val:String) {
			super();
			flag = val;
		}
       
        protected override function doValidation(value:Object):Array {
        	
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
        	if(value.fundCode == null || StringUtil.trim(value.fundCode) == "") {
        		results.push(new ValidationResult(true, 
	                    "fundCode", "fundCodeMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.wireinstructionpopup.fund')));
        	}
        	if(value.currency == null || StringUtil.trim(value.currency) == "") {
        		results.push(new ValidationResult(true, 
	                    "currency", "currencyMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.wireinstructionpopup.currency')));
        	}
        	if(flag!=null) {
        		if(value.cpAccountNo == null || StringUtil.trim(value.cpAccountNo) == "") {
	        		results.push(new ValidationResult(true, 
		                    "cpAccountNo", "cpAccountNoMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.wireinstructionpopup.cpaccountno')));
	        	}
        	}
        	return results;
        }
	}
}