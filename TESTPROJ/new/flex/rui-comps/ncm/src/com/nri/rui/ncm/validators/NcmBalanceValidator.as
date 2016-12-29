
  
package com.nri.rui.ncm.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    import mx.core.Application;
    
    /**
     * Custom Validator for NCM Movement Query Implementation.
     * 
     */    
    public class NcmBalanceValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results : Array;

        // constructor
        public function NcmBalanceValidator()
        {
            super();
        }
    
        /**
         * Checking valid input
         */
        private function checkValidNumber(number:String):Boolean {
            var length:int = number.length;
            var i:int = 0;
            if(isNaN(Number(number.charAt(0)))){      
                return false;         
            }
            while(i<length){
                if(isNaN(Number(number.charAt(i))) && (number.charAt(i) != '.')) {      
                    return false;
                }
                i++;
            }
            return true;
        }
       
        /**
         * Verifies whether a string is empty or null.
         */
        private function isBlank(str : String) : Boolean
        {
            if (str == null || StringUtil.trim(str) == "") {
                return true;
            }
            return false;
        }
       
        /**
         * validate movement query form
         */ 
        protected override function doValidation(value : Object) : Array
        {
            if (value == null) {
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('ncm.prompt.object.null'));
                return null;
            }
            
            var balanceBasis : String = value.balanceBasis;
            var date : String = value.date;
            var currency : String = value.currency;
            var securityCode : String = value.securityCode;
            var instrumentType : String = value.instrumentType;
            
            
            var flag : int = 0;
        
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            // Check movementBasis  field. 
            if (isBlank(balanceBasis)) 
            {
                results.push(new ValidationResult(true, 
                    "balanceBasis", "nobalanceBasis", Application.application.xResourceManager.getKeyValue('ncm.prompt.balance.basis')));
            }
            
            // Check date            
            if (isBlank(date)) 
            {
                results.push(new ValidationResult(true, 
                    "", "notoandfromDate", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.date')));
                return results;
            }
            
            // Validate 'dateFrom' and 'dateTo' date formats.
            var dateformat : CustomDateFormatter = new CustomDateFormatter();
            dateformat.formatString = "YYYYMMDD";
            var formatData : String = "";
            
            // Validate 'dateFrom' date format
            var fromDateObj : Date = null;
            formatData = dateformat.format(CustomDateFormatter.customizedInputDateString(date));
            if (DateUtils.isValidDate(date))
            {
                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(date));
                //Alert.show("fromDateObj :"+fromDateObj+" fromDate :"+fromDate+" formatData :"+formatData);
            }
            else
            {            
                results.push(new ValidationResult(true, 
                    "date", "illegalFromDate", "Invalid Date."));
                return results;
            }            
            
            
                        
            //Security and Currency cannot be entered together                    
            if (!isBlank(securityCode) && !isBlank(currency))
            {
                results.push(new ValidationResult(true,"","securityCodeandcurrencyBothNotRequird",Application.application.xResourceManager.getKeyValue('ncm.error.prompt.enter.ccysecurityboth')));    
                flag = 1;
            }
            if(!isBlank(instrumentType))
            {
            	instrumentType = instrumentType.toUpperCase();
            }
            //Security Type (CCY) and Security Code Cannot be entered together                   
            if (XenosStringUtils.equals("CCY",instrumentType) && !isBlank(securityCode))
            {
                results.push(new ValidationResult(true,"","securityTypeCCY",Application.application.xResourceManager.getKeyValue('ncm.error.prompt.enter.securitynotccy')));    
            }
            
            return results;        
        }        
    }
}