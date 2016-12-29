// ActionScript file

  
package com.nri.rui.ncm.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.utils.ObjectUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    import mx.core.Application;
    
    
    
    /**
     * Custom Validator for ncm Transaction Query Implementation.
     * 
     */    
    public class NcmTransactionQueryValidator extends Validator
    {
    	 // Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function NcmTransactionQueryValidator()
        {
            super();
        }
        
        /**
         * 
         * validate ncm transaction query form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
        	
        	if(value == null){
                XenosAlert.info("value object is null");
                return null;
            }
            
            var accNo:String = value.accNo;
            var securityCode:String = value.security;
            var currency:String = value.currency;
            var fromDate:String = value.entryDateFrom;
            var toDate:String = value.entryDateTo;
            var flag:int=0;
        	
        	
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;
            //return null;
            
            // Check account number  field. 
            if (XenosStringUtils.isBlank(accNo)) {
                results.push(new ValidationResult(true, 
                    "accNo", "noaccNo", Application.application.xResourceManager.getKeyValue('ncm.enter.prompt.bankaccount.no')));
                //return results;
            }
            
            
            // Check toDate and fromDate  field.           
            if (XenosStringUtils.isBlank(toDate) || XenosStringUtils.isBlank(fromDate)) {
                results.push(new ValidationResult(true, 
                    "", "notoandfromDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.fromto')));
                return results;
            }
            
            // Check to & Form Date Format . 
            var fromDateObj:Date = null;
            var toDateObj:Date=null;
            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            
            if(DateUtils.isValidDate(fromDate)){
                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(fromDate));
            }else{
                results.push(new ValidationResult(true, 
                            "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.from'))); 
            }
           
            if(DateUtils.isValidDate(toDate)){
                toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(toDate));
            }else{
                results.push(new ValidationResult(true, 
                            "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.to'))); 
            }
            
            // Return if there are errors for the fromDate or toDate.
            if (results.length > 0)
                return results;
            
            var comDate:int=ObjectUtil.dateCompare(fromDateObj,toDateObj);
            // check Form Date not less than To Date
            if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.fromlessto')));
            }
                        
            //Security and Currency cannot be entered together                    
            if(!XenosStringUtils.isBlank(securityCode) && !XenosStringUtils.isBlank(currency))
            {
                results.push(new ValidationResult(true,"","securityCodeandcurrencyBothNotRequird",Application.application.xResourceManager.getKeyValue('ncm.error.prompt.enter.ccysecurityboth')));    
                flag = 1;
            }
            
            if(XenosStringUtils.isBlank(securityCode) && XenosStringUtils.isBlank(currency))
            {
                results.push(new ValidationResult(true,"","securityCodeORcurrencyRequird",Application.application.xResourceManager.getKeyValue('ncm.error.prompt.enter.ccyorsecurity')));    
                flag = 1;
            }
            return results;
        }
    }
}