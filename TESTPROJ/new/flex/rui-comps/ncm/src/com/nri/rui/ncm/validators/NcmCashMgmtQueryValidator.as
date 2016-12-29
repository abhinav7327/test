
 
package com.nri.rui.ncm.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    import mx.core.Application;
    /**
     * Custom Validator for cam Portfolio Balance Query
     * 
     */ 
    public class NcmCashMgmtQueryValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function NcmCashMgmtQueryValidator()
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
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('ncm.prompt.object.validation.null'));
                return null;
            }
            var ccyBox:String =value.ccyBox;
            var bankCode : String = value.bankCode;
            var accountNo : String = value.accountNo;
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            
            //1. Validate baseDate  field.           
            /* if (XenosStringUtils.isBlank(ccyBox))
            {
                results.push(new ValidationResult(true, 
                    "", "ccyBox", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.currency.code')));
                return results;
            } */
            
            
            return results;
        }
    }
}