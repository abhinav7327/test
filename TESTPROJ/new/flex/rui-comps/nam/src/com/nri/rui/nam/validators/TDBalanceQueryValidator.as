
 
package com.nri.rui.nam.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    /**
     * Custom Validator for TD Balance Query
     * 
     */ 
    public class TDBalanceQueryValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function TDBalanceQueryValidator()
        {            
            super();
        }
        /**
         * 
         * validate TD Balance query form
         */
        protected override function doValidation(value:Object):Array
        {
            if(value == null)
            {
                XenosAlert.info("Validation object is null");
                return null;
            }
            var date:String =value.date;
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            
            //1. Validate date  field.           
            if (XenosStringUtils.isBlank(date))
            {
                results.push(new ValidationResult(true, 
                    "", "date", "Please enter Date."));
                return results;
            }
            // Check Date Format .            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            
            if(!DateUtils.isValidDate(date)){                
                results.push(new ValidationResult(true, 
                        "date", "invalidDate", "Invalid Date."));                
            }
            return results;
        }
    }
}