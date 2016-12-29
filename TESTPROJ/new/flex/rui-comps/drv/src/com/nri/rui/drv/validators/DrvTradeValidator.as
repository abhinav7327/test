
 
package com.nri.rui.drv.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    /**
     * Custom Validator for Derivative Trade Query
     */ 
    public class DrvTradeValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function DrvTradeValidator()
        {
            super();
        }
        
        /**
         * 
         * validate Drv Trade query form
         */       
        protected override function doValidation(value:Object):Array{
             if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('drv.alert.value.object.null'));
                return null;
            }
            var tradeDateFrom:String =value.tradeDateFrom;
            var tradeDateTo:String =value.tradeDateTo;
            var valueDateFrom:String =value.valueDateFrom;
            var valueDateTo:String =value.valueDateTo;
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;
                
            // Check Form & To Trade Date Format.            
            var dateFormatter:CustomDateFormatter =new CustomDateFormatter();
            var fromDateObj:Date = null;
            var toDateObj:Date = null;
            
            if (!XenosStringUtils.isBlank(tradeDateFrom)) {
                if(DateUtils.isValidDate(tradeDateFrom)){
                    fromDateObj = dateFormatter.toDate(CustomDateFormatter.customizedInputDateString(tradeDateFrom));
                }else{
                    results.push(new ValidationResult(true, 
                                "tradeDateFrom", "invalidTradeDateFrom", Application.application.xResourceManager.getKeyValue('drv.validator.invalid.tradedatefrm'))); 
                }
            }
            if (!XenosStringUtils.isBlank(tradeDateTo)) {
                if(DateUtils.isValidDate(tradeDateTo)){
                    toDateObj = dateFormatter.toDate(CustomDateFormatter.customizedInputDateString(tradeDateTo));
                }else{
                    results.push(new ValidationResult(true, 
                                "tradeDateTo", "invalidTradeDateTo", Application.application.xResourceManager.getKeyValue('drv.validator.invalid.tradedateto'))); 
                }
            }
            
            // Return if there are errors for the fromDate or toDate.
            if (results.length > 0)
                return results;
            
            // Check toDate and fromDate  field.           
            if (!XenosStringUtils.isBlank(tradeDateFrom) && !XenosStringUtils.isBlank(tradeDateTo)) {
                var comDate:int=ObjectUtil.dateCompare(fromDateObj,toDateObj);
                // check Form Date not less than To Date
                if (comDate==1) {
                    results.push(new ValidationResult(true, 
                         "", "fromDateLessThantoDate",  Application.application.xResourceManager.getKeyValue('drv.validator.tradedatefrm.lesstradedateto')));
                }
                return results;
            }
            
            // Check Form & To Value Date Format.            
            fromDateObj = null;
            toDateObj = null;
            
            if (!XenosStringUtils.isBlank(valueDateFrom)) {
                if(DateUtils.isValidDate(valueDateFrom)){
                    fromDateObj = dateFormatter.toDate(CustomDateFormatter.customizedInputDateString(valueDateFrom));
                }else{
                    results.push(new ValidationResult(true, 
                                "valueDateFrom", "invalidValueDateFrom",  Application.application.xResourceManager.getKeyValue('drv.validator.invalid.valuedatefrm'))); 
                }
            }
            if (!XenosStringUtils.isBlank(valueDateTo)) {
                if(DateUtils.isValidDate(valueDateTo)){
                    toDateObj = dateFormatter.toDate(CustomDateFormatter.customizedInputDateString(valueDateTo));
                }else{
                    results.push(new ValidationResult(true, 
                                "valueDateTo", "invalidValueDateTo",  Application.application.xResourceManager.getKeyValue('drv.validator.invalid.valuedateto'))); 
                }
            }
            
            // Return if there are errors for the fromDate or toDate.
            if (results.length > 0)
                return results;
            
            // Check toDate and fromDate  field.           
            if (!XenosStringUtils.isBlank(valueDateFrom) && !XenosStringUtils.isBlank(valueDateTo)) {
                comDate=ObjectUtil.dateCompare(fromDateObj,toDateObj);
                // check Form Date not less than To Date
                if (comDate==1) {
                    results.push(new ValidationResult(true, 
                         "", "fromDateLessThantoDate",  Application.application.xResourceManager.getKeyValue('drv.validator.valuedatefrm.lessvaluedateto')));
                }
                return results;
            }
            
            return results;
        }
        
    }
}