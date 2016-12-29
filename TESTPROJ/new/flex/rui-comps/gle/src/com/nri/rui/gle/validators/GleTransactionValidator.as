
 
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
     * Custom Validator for Gle Transaction Query
     * 
     */ 
    public class GleTransactionValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function GleTransactionValidator()
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
            
            var balanceEntryDate:String = value.balanceEntryDate;
            var balanceEntryDateTo:String = value.balanceEntryDateTo;
                                
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
            //4. Validate Mandatory field balanceEntryDate.           
            if (XenosStringUtils.isBlank(balanceEntryDate))
            {
                results.push(new ValidationResult(true, 
                    "", "balanceEntryDate", Application.application.xResourceManager.getKeyValue('gle.label.entry.date.from')));
                //return results;
            }

            if (XenosStringUtils.isBlank(balanceEntryDateTo))
            {
                results.push(new ValidationResult(true, 
                    "", "balanceEntryDateTo", Application.application.xResourceManager.getKeyValue('gle.label.entry.date.to')));
                //return results;
            }


            if (results.length > 1)
                return results;
            else
                results = []; //Refresh for Other type of errors
            
            //Validation for dates
            
            //balanceEntryDate
            if (!XenosStringUtils.isBlank(balanceEntryDate))
            {
                 // Check base Date Format .                
                var dateformat:CustomDateFormatter =new CustomDateFormatter();
                //format of the date
                dateformat.formatString="YYYYMMDD";
                var formatDate:String ="";
                
                formatDate=dateformat.format(CustomDateFormatter.customizedInputDateString(balanceEntryDate));
                if(XenosStringUtils.isBlank(StringUtil.trim(formatDate))){            
                    results.push(new ValidationResult(true, 
                        "baseDate", "baseDate", Application.application.xResourceManager.getKeyValue('gle.label.Illegal.balance.entry.date')));
                    return results;
                }
            }
            //balanceEntryDate
            if (!XenosStringUtils.isBlank(balanceEntryDateTo))
            {
                // Check Date Format .
                var datefmt:CustomDateFormatter =new CustomDateFormatter();
                //format of the date
                datefmt.formatString="YYYYMMDD";
                var formatttedDate:String ="";
                
                formatttedDate=datefmt.format(CustomDateFormatter.customizedInputDateString(balanceEntryDateTo));
                if(XenosStringUtils.isBlank(StringUtil.trim(formatttedDate))){            
                    results.push(new ValidationResult(true, 
                        "baseDate", "baseDate", Application.application.xResourceManager.getKeyValue('gle.label.Illegal.balance.entry.date.to')));
                    return results;
                }
            }            
            
            return results;
        }
    }
}