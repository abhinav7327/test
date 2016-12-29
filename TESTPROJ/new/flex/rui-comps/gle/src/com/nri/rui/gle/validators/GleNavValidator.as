
 
package com.nri.rui.gle.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    /**
     * Custom Validator for cam Portfolio Balance Query
     * 
     */ 
    public class GleNavValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function GleNavValidator()
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
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('gle.error.validation.object.null'));
                return null;
            }
            
            var valuationDate:String = value.valuationDate;
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            //Checking for null values of the mandatory fields
            results.push(new ValidationResult(true, 
                    "", "Missing", Application.application.xResourceManager.getKeyValue('gle.label.enter.fields')));
            
            if (results.length > 1)
                return results;
            else
                results = []; //Refresh for Other type of errors
            
            //Validation for dates
            
            //balanceEntryDate
            if (!XenosStringUtils.isBlank(valuationDate))
            {
                 // Check base Date Format .                
                var dateformat:CustomDateFormatter =new CustomDateFormatter();
                //format of the date
                dateformat.formatString="YYYYMMDD";
                var formatDate:String ="";
                
                formatDate=dateformat.format(CustomDateFormatter.customizedInputDateString(valuationDate));
                if(XenosStringUtils.isBlank(StringUtil.trim(formatDate))){            
                    results.push(new ValidationResult(true, 
                        "baseDate", "baseDate", Application.application.xResourceManager.getKeyValue('gle.label.Illegal.valuation.date')));
                    return results;
                }
            }
            
            return results;
        }
    }
}