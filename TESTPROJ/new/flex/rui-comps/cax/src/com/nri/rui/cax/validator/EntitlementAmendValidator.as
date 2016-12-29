




 
 /**
 * EntitlementAmendValidator - Validator for Entitlement Amend UI.
 * @author prabjyotk
 * @version 
 */ 
package com.nri.rui.cax.validator
{
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;  
    
	public class EntitlementAmendValidator extends Validator {
		
		// Define Array for the return value of doValidation().
        private var results:Array;

       /**
       	*  Default Constructor
       	*/
		public function EntitlementAmendValidator() {
			super();
		}
		
		/**
         * Method to validate client side for the mandatory fields.
         * @override
         * @see mx.validators.Validator.doValidation
         * 
         */        
        protected override function doValidation(value:Object):Array {      	
        	
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
            
          	if (value.hasOwnProperty("taxFeeId") && XenosStringUtils.isBlank(value.taxFeeId))
       				results.push(new ValidationResult(true, 
                    	"taxFeeId", "taxFeeIdMissing", Application.application.xResourceManager.getKeyValue('cax.validate.tax.fee.id'))); 
                    	
            if (value.hasOwnProperty("amount") && XenosStringUtils.isBlank(value.amount))
        			results.push(new ValidationResult(true, 
                   		"amount", "amountMissing", Application.application.xResourceManager.getKeyValue('cax.validate.amount')));
                   		
        	if (value.hasOwnProperty("rate") && XenosStringUtils.isBlank(value.rate))
        			results.push(new ValidationResult(true, 
                    	"rate", "rateMissing", Application.application.xResourceManager.getKeyValue('cax.validate.rate')));
                    	
            if (value.hasOwnProperty("rateType") && XenosStringUtils.isBlank(value.rateType))      
            		results.push(new ValidationResult(true, 
                       "rateType", "rateTypeMissing",  Application.application.xResourceManager.getKeyValue('cax.validate.rate.type')));
                       
            if (value.hasOwnProperty("securityBalanceStr") && XenosStringUtils.isBlank(value.securityBalanceStr))      
            		results.push(new ValidationResult(true, 
                       "securityBalanceStr", "securityBalanceStrMissing", Application.application.xResourceManager.getKeyValue('cax.validate.security.balance')));
            
            if (value.hasOwnProperty("paymentDateStr") && XenosStringUtils.isBlank(value.paymentDateStr))      
            		results.push(new ValidationResult(true, 
                       "paymentDateStr", "paymentDateStrMissing", Application.application.xResourceManager.getKeyValue('cax.validate.paymentdate.blank')));                        
        
        	return results;
        }
		
	}
	
}
