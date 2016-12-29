
  
package com.nri.rui.cam.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.NumberUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    
    /**
     * Custom Validator for Cam Movement Query Implementation.
     * 
     */    
    public class UnrealizedPlValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function UnrealizedPlValidator()
        {
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
            var balanceBasis:String =value.balanceBasis;
            var baseDate:String=value.baseDate;
            var flag:int=0;
        
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            // Check balanceBasis  field. 
            if (XenosStringUtils.isBlank(balanceBasis)) {
                results.push(new ValidationResult(true, 
                    "balanceBasis", "invalidBalanceBasis", Application.application.xResourceManager.getKeyValue('cam.label.select.balance.basis')));
            }
           
                        
            
            //Base Date validation
            if(!XenosStringUtils.isBlank(baseDate)){
                if(!DateUtils.isValidDate(baseDate)){                
                    results.push(new ValidationResult(true, 
                            "baseDate", "invalidBaseDate", Application.application.xResourceManager.getKeyValue('cam.label.invalid.base.date'))); 
                }
            }
            
            return results;        
        }        
    }
}