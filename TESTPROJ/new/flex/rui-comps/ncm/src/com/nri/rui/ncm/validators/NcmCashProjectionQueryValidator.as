
  
package com.nri.rui.ncm.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

    /**
     * Custom Validator for Ncm Cash Projection Query - Cash Projection Query Implementation.
     * 
     */    
    public class NcmCashProjectionQueryValidator extends Validator
    {
    	// Define Array for the return value of doValidation().
        private var results:Array;

        // Constructor
 	public function NcmCashProjectionQueryValidator() {
            super();
        }
        
        /**
          * Validate movement query form.
          */ 
       
        protected override function doValidation(value:Object):Array {
            if(value == null) {
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('ncm.prompt.object.null'));
                return null;
            }
            var fundCode:String = value.fundCode;
            var dateFrom:String = value.dateFrom;
            var dateTo:String = value.dateTo;
            var flag:int = 0;
        
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0) {
                return results;
            }
			// Fund Code Validation
/* 			if(XenosStringUtils.isBlank(fundCode)){
				results.push(new ValidationResult(true, "", "noFundCode", "Please enter the Fund Code."));
			}
 */			
            // Base Date validation.
            if(XenosStringUtils.isBlank(dateFrom)) {
            	results.push(new ValidationResult(true, "", "noDateFrom", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.from.date')));
            } else {
                if(!DateUtils.isValidDate(dateFrom)) {                
                    results.push(new ValidationResult(true, "dateFrom", "invalidDateFrom", Application.application.xResourceManager.getKeyValue('ncm.prompt.invalid.date.from'))); 
                }
	    }            
            if(XenosStringUtils.isBlank(dateTo)) {
            	results.push(new ValidationResult(true, "", "noDateTo", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.to.date')));
            } else {
                if(!DateUtils.isValidDate(dateTo)) {                
                    results.push(new ValidationResult(true, "dateTo", "invalidDateTo", Application.application.xResourceManager.getKeyValue('ncm.prompt.invalid.to.date'))); 
                }
	    }            
            return results;        
        }
    }
}
