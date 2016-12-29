
  
package com.nri.rui.cam.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
    import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

    /**
     * Custom Validator for Cam Total Query - Portfolio Balance Query Implementation.
     * 
     */    
    public class CamTotalPortfolioBalanceQueryValidator extends Validator
    {
    	// Define Array for the return value of doValidation().
        private var results:Array;

        // Constructor
 	public function CamTotalPortfolioBalanceQueryValidator() {
            super();
        }
        
        /**
          * Validate movement query form.
          */ 
       
        protected override function doValidation(value:Object):Array {
            if(value == null) {
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('cam.label.object.null'));
                return null;
            }
            var balanceType:String = value.balanceType;
            var baseDate:String = value.baseDate;
            var flag:int = 0;
        
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0) {
                return results;
            }

            // Check BalanceBasis  field. 
            if (XenosStringUtils.isBlank(balanceType)) {
                results.push(new ValidationResult(true, "balanceType", "invalidBalanceType", Application.application.xResourceManager.getKeyValue('cam.label.select.balance.type')));
            }          
            
            // Base Date validation.
            if(XenosStringUtils.isBlank(baseDate)) {
            	results.push(new ValidationResult(true, "", "noDate", Application.application.xResourceManager.getKeyValue('cam.label.enter.date')));
            } else {
                if(!DateUtils.isValidDate(baseDate)) {                
                    results.push(new ValidationResult(true, "baseDate", "invalidBaseDate", Application.application.xResourceManager.getKeyValue('cam.label.illegal.date.format') + baseDate)); 
                }
	    }            
            return results;        
        }
    }
}
