
package com.nri.rui.ncm.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	import com.nri.rui.core.validators.XenosNumberValidator;
	
	import mx.events.ValidationResultEvent;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

    /**
     * Custom Validator for Forex Adjustment Entry Implementation.
     * 
     */    
	public class ForexAdjustmentValidator extends Validator
	{
        // Define Array for the return value of doValidation().
        private var results:Array;
        
		public function ForexAdjustmentValidator()
		{
			super();
		}
        /**
         * Validate Forex Adjustment Entry Form
         */ 
        protected override function doValidation(value:Object):Array
        {
            if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('ncm.prompt.object.null'));
                return null;
            }
            var fund:String = value.fundCode;
			var inCcy:String = value.inCcy;
			var outCcy:String = value.outCcy;
			var inAmount:String = value.inAmount;
			var outAmount:String = value.outAmount;
			var inBank:String = value.inBank;
			var outBank:String = value.outBank;
			var inAccountNo:String = value.inAccountNo;
			var outAccountNo:String = value.outAccountNo;
			var adjustmentDate:String = value.adjustmentDate;
			var inNumberValidator:XenosNumberValidator = value.inNumValidator;
			var outNumberValidator:XenosNumberValidator = value.outNumValidator;
			
            // Clear results Array.
            results = [];
            // Call base class's doValidation().
            results = super.doValidation(value);
            // Return if there are errors.
            if (results.length > 0)
                return results;
			
            // Check fund Code field.
            if (XenosStringUtils.isBlank(fund)) {
                results.push(new ValidationResult(true, 
                    "fund", "nofund", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.fund.code')));
            }  
            // Check in currency field.
            if (XenosStringUtils.isBlank(inCcy)) {
                results.push(new ValidationResult(true, 
                    "", "currency", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.currency.in')));
            } 
            // Check out currency field.
            if (XenosStringUtils.isBlank(outCcy)) {
                results.push(new ValidationResult(true, 
                    "", "currency", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.currency.out')));
            } 
            // Check in amount field.
            if (XenosStringUtils.isBlank(inAmount)) {
                results.push(new ValidationResult(true, 
                    "", "amount", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.amount.in')));
            }
            // Check out amount field.
            if (XenosStringUtils.isBlank(outAmount)) {
                results.push(new ValidationResult(true, 
                    "", "amount", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.amount.out')));
            }
            // Check in bank field. 
            if (XenosStringUtils.isBlank(inBank)) {
                results.push(new ValidationResult(true, 
                    "", "finInst", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.bank.in')));
            }  
            // Check out bank field.
            if (XenosStringUtils.isBlank(outBank)) {
                results.push(new ValidationResult(true, 
                    "", "finInst", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.bank.out')));
            }  
            // Check in account number  field. 
            if (XenosStringUtils.isBlank(inAccountNo)) {
                results.push(new ValidationResult(true, 
                    "accNo", "noaccNo", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.cash.account.in')));
            }  
            // Check out account number  field. 
            if (XenosStringUtils.isBlank(outAccountNo)) {
                results.push(new ValidationResult(true, 
                    "accNo", "noaccNo", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.cash.account.out')));
            }  
            
            // Check adjustmentDate  field.           
            if (XenosStringUtils.isBlank(adjustmentDate)) {
                results.push(new ValidationResult(true, 
                    "", "adjustDate", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.adjustment.date')));
            }
            if(results.length > 0 ){ 
                return results;    
            }
            
            // Check if in ccy and out ccy are same.
            if (XenosStringUtils.equals(inCcy, outCcy)) {
                results.push(new ValidationResult(true, 
                    "", "currency", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.currency.innotsameout')));
            } 
            //Check if the in amount is negative
	    	var vResult:ValidationResultEvent;
	    	vResult = inNumberValidator.validate();
	    	if (vResult.type==ValidationResultEvent.INVALID) {
	     		results.push(new ValidationResult(true, "", "amount", vResult.message)); 
	    	}         
            //Check if the in amount is negative
	    	vResult = outNumberValidator.validate();
	    	if (vResult.type==ValidationResultEvent.INVALID) {
	     		results.push(new ValidationResult(true, "", "amount", vResult.message)); 
	    	}         
            //Check the AdjustmentDate Format
            if(!DateUtils.isValidDate(adjustmentDate)){
                results.push(new ValidationResult(true, 
					"adjustDate", "adjustDate", Application.application.xResourceManager.getKeyValue('ncm.prompt.error.adjustment.date'))); 
            }
			
			return results;
        }
	}
}