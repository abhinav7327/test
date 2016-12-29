
 
package com.nri.rui.gle.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    /**
     * Custom Validator for cam Portfolio Balance Query
     * 
     */ 
    public class GleJournalValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function GleJournalValidator()
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
            
            var ledgerCodeFrom:String = value.ledgerCodeFrom;
            var ledgerCodeTo:String = value.ledgerCodeTo;
            var currency:String = value.currency;
            var balanceEntryDate:String = value.balanceEntryDate;
            var balanceEntryDateTo:String = value.balanceEntryDateTo;
            var balanceType:String = value.balanceType;                                
                                
            //var balanceBasis:String =value.balanceBasis;
            //var baseDate:String =value.baseDate;
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
            //1. Validate Mandatory field ledgerCodeFrom.           
            if (XenosStringUtils.isBlank(ledgerCodeFrom))
            {
                results.push(new ValidationResult(true, 
                    "", "ledgerCodeFrom", Application.application.xResourceManager.getKeyValue('gle.label.ledger.code.from')));
                //return results;
            }
            //2. Validate Mandatory field ledgerCodeTo.           
            if (XenosStringUtils.isBlank(ledgerCodeTo))
            {
                results.push(new ValidationResult(true, 
                    "", "ledgerCodeTo", Application.application.xResourceManager.getKeyValue('gle.label.ledger.code.to')));
                //return results;
            }
            //3. Validate Mandatory field currency.           
            if (XenosStringUtils.isBlank(currency))
            {
                results.push(new ValidationResult(true, 
                    "", "currency", Application.application.xResourceManager.getKeyValue('gle.label.currency')));
                //return results;
            }
            //4. Validate Mandatory field balanceEntryDate.           
            if (XenosStringUtils.isBlank(balanceEntryDate))
            {
                results.push(new ValidationResult(true, 
                    "", "balanceEntryDate", Application.application.xResourceManager.getKeyValue('gle.label.balance.entry.date')));
                //return results;
            }
            //5. Validate Mandatory field balanceType.           
            if (XenosStringUtils.isBlank(balanceType))
            {
                results.push(new ValidationResult(true, 
                    "", "balanceType", Application.application.xResourceManager.getKeyValue('gle.label.balance.type')));
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
                if(XenosStringUtils.isBlank(StringUtil.trim(formatDate)) || (!DateUtils.isValidDate(balanceEntryDate))){            
                    results.push(new ValidationResult(true, 
                        "baseDate", "baseDate", Application.application.xResourceManager.getKeyValue('gle.label.invalid.date')));
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
                if(XenosStringUtils.isBlank(StringUtil.trim(formatttedDate)) || (!DateUtils.isValidDate(balanceEntryDateTo))){            
                    results.push(new ValidationResult(true, 
                        "baseDate", "baseDate", Application.application.xResourceManager.getKeyValue('gle.label.invalid.date.to')));
                    return results;
                }
            }            
            
            return results;
        }
    }
}