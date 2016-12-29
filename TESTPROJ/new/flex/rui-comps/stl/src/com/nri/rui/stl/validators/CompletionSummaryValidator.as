
package com.nri.rui.stl.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	/**
     * Custom Validator for Stl Completion Summary Implementation.
     * 
     */
	public class CompletionSummaryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        
		public function CompletionSummaryValidator()
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
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.completion.summary.validate.valueobject'));
                return null;
            }
            
            var currency:String=value.ccy;
            var ourAccountNo:String=value.ourAccNo;
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
            
            // Check A/C  field. 
            if (XenosStringUtils.isBlank(ourAccountNo)) {
                results.push(new ValidationResult(true, 
                    "ourAccountNo", "ourAccountNo", Application.application.xResourceManager.getKeyValue('stl.label.completion.summary.validate.settlement.account')));
            }
            // Check ccy  field. 
            if (XenosStringUtils.isBlank(currency)) {
                results.push(new ValidationResult(true, 
                    "currency", "currency", Application.application.xResourceManager.getKeyValue('stl.label.completion.summary.validate.settlement.ccy')));
            }
            
             return results;  
		}
	}	
}