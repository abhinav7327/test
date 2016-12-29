
 
package com.nri.rui.icn.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    /**
     * Custom Validator for feed Query
     * 
     */ 
    public class FeedResendQueryValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function FeedResendQueryValidator()
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
                XenosAlert.info("Validation object is null");
                return null;
            }
            //var interfaceId:String =value.interfaceId;
            var applDate:String =value.applDate;
            var officeId:String =value.officeId;
            var interfacegroup:String =value.interfacegroup;
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            
            //1. Validate baseDate  field.           
            if (XenosStringUtils.isBlank(applDate))
            {
                results.push(new ValidationResult(true, 
                    "", "baseDate", "Please enter Feed Creation Date."));
                return results;
            }
            // Check base Date Format .            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            
            if(!DateUtils.isValidDate(applDate)){                
                results.push(new ValidationResult(true, 
                        "baseDate", "invalidBaseDate", "Invalid Date."));                
            }

            
            //2. Check office id. 
            if (XenosStringUtils.isBlank(officeId))
            {
                results.push(new ValidationResult(true, 
                    "officeId", "officeId", "Please Select Office Id"));
                return results;
            }
            
            //2. Check interface type. 
            if (XenosStringUtils.isBlank(interfacegroup))
            {
                results.push(new ValidationResult(true, 
                    "interfacegroup", "interfacegroup", "Please Select Interface Type"));
                return results;
            }
            

                       
            
            return results;
        }
    }
}