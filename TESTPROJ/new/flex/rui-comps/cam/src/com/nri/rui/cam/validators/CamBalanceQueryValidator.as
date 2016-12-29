
 
package com.nri.rui.cam.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    /**
     * Custom Validator for cam Portfolio Balance Query
     * 
     */ 
    public class CamBalanceQueryValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function CamBalanceQueryValidator()
        {            
            super();
        }
        /**
         * 
         * validate movement query form
         */
        protected override function doValidation(value:Object):Array
        {
            if(value == null)
            {
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('cam.label.object.null'));
                return null;
            }
            var balanceBasis:String =value.balanceBasis;
            var baseDate:String =value.baseDate;
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            
            //1. Validate baseDate  field.           
            if (XenosStringUtils.isBlank(baseDate))
            {
                results.push(new ValidationResult(true, 
                    "", "baseDate",Application.application.xResourceManager.getKeyValue('cam.label.enter.date')));
                return results;
            }
            // Check base Date Format .            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            
            if(!DateUtils.isValidDate(baseDate)){                
                results.push(new ValidationResult(true, 
                        "baseDate", "invalidBaseDate",Application.application.xResourceManager.getKeyValue('cam.label.invalid.date')));                
            }
            
            //2. Check balanceBasis field. 
            if (XenosStringUtils.isBlank(balanceBasis))
            {
                results.push(new ValidationResult(true, 
                    "balanceBasis", "balanceBasis", Application.application.xResourceManager.getKeyValue('cam.label.select.balance.basis')));
                return results;
            }
            
            return results;
        }
    }
}