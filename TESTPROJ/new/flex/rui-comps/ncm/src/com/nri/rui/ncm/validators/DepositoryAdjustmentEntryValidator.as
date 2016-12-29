
package com.nri.rui.ncm.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    import mx.core.Application;
    
    /**
     * Custom Validator for Depository Adjustment Entry Implementation.
     * 
     */    
    public class DepositoryAdjustmentEntryValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function DepositoryAdjustmentEntryValidator()
        {
            super();
        }
        
        /**
         * 
         * validate Depository adjustment entry form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
            if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('ncm.prompt.object.null'));
                return null;
            }
            
            var fund:String = value.fundCode;
            var finInst:String = value.bankCode;
            var accNo:String = value.accountNo;
            var adjustDate : String = value.adjustmentDate;
            var adjustType : String = value.adjustmentType;
            var reason : String = value.adjustmentReason;
            var insCode:String = value.instrumentId;
            var quantity : String = value.quantity;
            
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
            
             
            // Check instrument code  field. 
            if (XenosStringUtils.isBlank(insCode)) {
                results.push(new ValidationResult(true, 
                    "insCode", "noInsCode", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.security.code')));
            } 
            // Check quantity  field. 
            if (XenosStringUtils.isBlank(quantity)) {
                results.push(new ValidationResult(true, 
                    "", "quantity", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.quantity')));
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
            if (XenosStringUtils.isBlank(reason)) {
                results.push(new ValidationResult(true, 
                    "", "reason", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.adjustment.reason')));
            }  
             if(results.length > 0 ){ 
                return results;    
            }
            
            //Check the AdjustmentDate Format
            if(!DateUtils.isValidDate(adjustDate)){
                results.push(new ValidationResult(true, 
                            "adjustDate", "adjustDate", Application.application.xResourceManager.getKeyValue('ncm.prompt.error.adjustment.date'))); 
            }
            return results;    
        }
     }       
}