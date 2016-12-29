// ActionScript file


package com.nri.rui.gle.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
   
    
    /**
     * Custom Validator for VoucherEntry Implementation.
     * 
     */   
	public class VoucherEntryValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function VoucherEntryValidator()
        {
            super();
        }
               
        /**
         * 
         * validate movement query form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
            if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('gle.error.validation.object.null'));
                return null;
            }
            
           var ccy:String=StringUtil.trim(value.ccy as String);
           var date:String=StringUtil.trim(value.date as String); 
           var accountNo:String=StringUtil.trim(value.accountNo as String); 
           var invAccountNo:String=StringUtil.trim(value.invAccountNo as String); 
           var trialBalanceId:String=StringUtil.trim(value.trialBalanceId as String); 
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
            
            
            
            // Currency validation
            if(XenosStringUtils.isBlank(ccy)){
                    results.push(new ValidationResult(true, 
                            "ccy", "emptyCcy", Application.application.xResourceManager.getKeyValue('gle.label.enter.currency')));               
            }
            
            // Transaction Date validation
            if(XenosStringUtils.isBlank(date)){
                    results.push(new ValidationResult(true, 
                            "date", "emptydate",  Application.application.xResourceManager.getKeyValue('gle.label.enter.date')));               
            }
            
            if(XenosStringUtils.isBlank(accountNo) && XenosStringUtils.isBlank(trialBalanceId) && XenosStringUtils.isBlank(invAccountNo)){
            	results.push(new ValidationResult(true, 
                            "account", "emptyAccount", Application.application.xResourceManager.getKeyValue('gle.label.enter.trialbalance.or.account')));   
            }
            
            if(results.length>0)
            	return results;
            
            // Transaction Date validation
            if(!XenosStringUtils.isBlank(date)){
                if(!DateUtils.isValidDate(date)){                
                    results.push(new ValidationResult(true, 
                            "date", "invaliddate", Application.application.xResourceManager.getKeyValue('gle.label.invalid.date'))); 
                }
            }
                 
           
        	return results;
        }
	}
}