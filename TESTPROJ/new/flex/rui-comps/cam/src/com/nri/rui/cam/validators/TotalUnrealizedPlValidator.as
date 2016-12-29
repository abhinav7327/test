
  
package com.nri.rui.cam.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
    import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

    /**
     * Custom Validator for Cam Movement Query Implementation.
     * 
     */    
    public class TotalUnrealizedPlValidator extends Validator
    {
    	// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
 	   public function TotalUnrealizedPlValidator(){
            super();
        }
        
                /**
         * 
         * validate movement query form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
            if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('cam.label.object.null'));
                return null;
            }
            var balanceType:String =value.balanceType;
            var plDate:String=value.plDate;
            var flag:int=0;
        
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            // Check balanceBasis  field. 
            if (XenosStringUtils.isBlank(balanceType)) {
                results.push(new ValidationResult(true, 
                    "balanceType", "invalidBalanceType", Application.application.xResourceManager.getKeyValue('cam.label.select.balance.type')));
            }
           
                        
            
            //Base Date validation
            if(XenosStringUtils.isBlank(plDate)){
            	results.push(new ValidationResult(true,
            				"","noDate",Application.application.xResourceManager.getKeyValue('cam.label.enter.date')));
            }
            
            
            if(!XenosStringUtils.isBlank(plDate)){
                if(!DateUtils.isValidDate(plDate)){                
                    results.push(new ValidationResult(true, 
                            "baseDate", "invalidBaseDate", Application.application.xResourceManager.getKeyValue('cam.label.illegal.date.format') + plDate)); 
                }
            }
            
            return results;        
        }
    }
}
