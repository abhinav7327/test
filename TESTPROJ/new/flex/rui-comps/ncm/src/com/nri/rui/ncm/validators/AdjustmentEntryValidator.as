
package com.nri.rui.ncm.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.NumberUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    import mx.core.Application;
    
    /**
     * Custom Validator for Nostro Adjustment Entry Implementation.
     * 
     */    
    public class AdjustmentEntryValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function AdjustmentEntryValidator()
        {
            super();
        }
        
        /**
         * 
         * validate ncm adjustment entry form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
            if(value == null){
                XenosAlert.info("value object is null");
                return null;
            }
            
            var fund:String = value.fundCode;
            var finInst:String = value.bankCode;
            var ledger:String = value.gleledger;
            var accNo:String = value.accountNo;
            var currency:String = value.ccyCode;
            var amt : String = value.amount;
            var adjustDate : String = value.adjustmentDate;
            var adjustType : String = value.adjustmentType;
            var reason : String = value.adjustmentReason;
            
            //XenosAlert.info("Amount :"+amt);
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;
            
            // Check fund Code  field. 
            if (XenosStringUtils.isBlank(fund)) {
                results.push(new ValidationResult(true, 
                    "fund", "nofund", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.fund.code')));
            }  
            // Check currency  field. 
            if (XenosStringUtils.isBlank(currency)) {
                results.push(new ValidationResult(true, 
                    "", "currency", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.currency.code')));
            } 
            // Check Bank / Custodian Code  field. 
            if (XenosStringUtils.isBlank(finInst)) {
                results.push(new ValidationResult(true, 
                    "", "finInst", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.bank.code')));
            }  
            // Check account number  field. 
            if (XenosStringUtils.isBlank(accNo)) {
                results.push(new ValidationResult(true, 
                    "accNo", "noaccNo", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.bank.account')));
            }  
            // Check amount  field. 
            if (XenosStringUtils.isBlank(amt)) {
                results.push(new ValidationResult(true, 
                    "", "amount", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.amount')));
            }
            
            // Check adjustmentDate  field.           
            if (XenosStringUtils.isBlank(adjustDate)) {
                results.push(new ValidationResult(true, 
                    "", "adjustDate", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.adjustment.date')));
                
            } 
            // Check adjustmentType  field. 
            if (XenosStringUtils.isBlank(adjustType)) {
                results.push(new ValidationResult(true, 
                    "", "adjustType", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.adjustment.type')));
            } 
            // Check adjustmentReason field. 
            /*
            if (XenosStringUtils.isBlank(reason)) {
                results.push(new ValidationResult(true, 
                    "", "reason", "Please enter Adjustment Reason."));
            } 
            */
            // Check gleLedgerCode field. 
            if (XenosStringUtils.isBlank(ledger)) {
                results.push(new ValidationResult(true, 
                    "", "ledger", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.ledger.code')));
            } 
            if(results.length > 0 ){ 
                return results;    
            }
            
            //Check the AdjustmentDate Format
            if(!DateUtils.isValidDate(adjustDate)){
                results.push(new ValidationResult(true, 
                            "adjustDate", "adjustDate", Application.application.xResourceManager.getKeyValue('ncm.prompt.error.adjustment.date'))); 
            }
//            var dateformat:CustomDateFormatter =new CustomDateFormatter();
//            //format of the date
//            dateformat.formatString="YYYYMMDD";
//            var formatData:String ="";
//            
//            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(adjustDate));
//            if(XenosStringUtils.isBlank(StringUtil.trim(formatData))){
//                results.push(new ValidationResult(true, 
//                    "adjustDate", "adjustDate", "Illegal format of  Adjustment Date."));
//              
//            }
            
            //Check the amount format
            /* if(!NumberUtils.checkValidNumber(amt)){
                results.push(new ValidationResult(true,"","amount",
                                                            "Amount must be numeric.")); 
                
            } */
            
            return results;    
            
        }
     }       
}