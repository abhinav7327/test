
  
package com.nri.rui.ncm.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    import mx.core.Application;
    
    /**
     * Custom Validator for NCM Movement Query Implementation.
     * 
     */    
    public class MovementBalanceValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results : Array;

        // constructor
        public function MovementBalanceValidator()
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
            
            var movementBasis : String = value.movementBasis;
            var dateFrom : String = value.dateFrom;
            var dateTo : String = value.dateTo;
            var instrumentType : String = value.instrumentType;
            var currency : String = value.currency;
            var securityCode : String = value.securityCode;
            var bankCode : String = value.bankCode;
            var accountNo : String = value.accountNo;
//            var tradingAccountNo : String = value.tradingAccountNo;
            
            var flag : int = 0;
        
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            // Check movementBasis  field. 
            if (isBlank(movementBasis)) 
            {
                results.push(new ValidationResult(true, 
                    "movementBasis", "nomovementBasis", Application.application.xResourceManager.getKeyValue('ncm.prompt.movement.basis')));
            }
            
            // Check dateFrom and dateTo field.           
            if (isBlank(dateTo) || isBlank(dateFrom)) 
            {
                results.push(new ValidationResult(true, 
                    "", "notoandfromDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.fromto')));
                return results;
            }
            
            // Validate 'dateFrom' and 'dateTo' date formats.
            var dateformat : CustomDateFormatter = new CustomDateFormatter();
            
            var fromDateObj : Date = null;
            if(DateUtils.isValidDate(dateFrom)){
                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateFrom));
            }else{
                results.push(new ValidationResult(true, 
                            "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.from'))); 
            }
            
            
            var toDateObj:Date=null;
            if(DateUtils.isValidDate(dateTo)){
                toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateTo));
            }else{
                results.push(new ValidationResult(true, 
                            "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.to'))); 
            }
           
            // Return if there are errors for the fromDate or toDate.
            if (results.length > 0)
                return results;

            // Validate 'fromDate' not less than 'toDate'
            var comDate : int = ObjectUtil.dateCompare(fromDateObj, toDateObj);
            if (comDate == 1) 
            {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.fromlessto')));
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
            //Security Type(CCY) and Security Code Cannot be entered together                   
            if (XenosStringUtils.equals("CCY",instrumentType) && !isBlank(securityCode))
            {
                results.push(new ValidationResult(true,"","securityTypeCCY",Application.application.xResourceManager.getKeyValue('ncm.error.prompt.enter.securitynotccy')));    
            }
            
            return results;        
        }        
    }
}