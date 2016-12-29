// ActionScript file


package com.nri.rui.ref.validators
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
   
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */
	public class OwnSettleStandingEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function OwnSettleStandingEntryValidator() {
			super();
		}
		
		/**
         * 
         * validate movement query form
         */ 
       
        protected override function doValidation(value:Object):Array {
        	
        	        	
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
        	
        	
        	if(value.mode =="entry") {
        		
        		if(value.fundCode == null || StringUtil.trim(value.fundCode) == ""){
        		 results.push(new ValidationResult(true, 
	                    "fundCode", "fundCodeMissing", 
Application.application.xResourceManager.getKeyValue('ref.ownsettlestanding.alert.validator.entry.fundcode')));
	                    
        		}
        		if(value.settlementFor == null || StringUtil.trim(value.settlementFor) == ""){
        		 results.push(new ValidationResult(true, 
	                    "settlementFor", "settlementForMissing", 
Application.application.xResourceManager.getKeyValue('ref.ownsettlestanding.alert.validator.entry.settlementfor')));
	                    
        		}
        		if(value.cashSecurityFlag == null || StringUtil.trim(value.cashSecurityFlag) == ""){
        		 results.push(new ValidationResult(true, 
	                    "cashSecurityFlag", "cashSecurityFlagMising", 
Application.application.xResourceManager.getKeyValue('ref.ownsettlestanding.alert.validator.entry.cashsecurityflag')));
	                    
        		}
        	}
        	if(value.defaultrule =="false") {
        		
        		if(value.settlementBank == null || StringUtil.trim(value.settlementBank) == ""){
        		 results.push(new ValidationResult(true, 
	                    "settlementBank", "settlementBankMissing", 
Application.application.xResourceManager.getKeyValue('ref.ownsettlestanding.alert.validator.entry.settlebank')));
	                    
        		}
        		if(value.settlementAccount == null || StringUtil.trim(value.settlementAccount) == ""){
        		 results.push(new ValidationResult(true, 
	                    "settlementBank", "settlementBankMissing", 
Application.application.xResourceManager.getKeyValue('ref.ownsettlestanding.alert.validator.entry.settleaccount')));
	                    
        		}
        	}
        	
        	
        	if(value.settlementMode == null || StringUtil.trim(value.settlementMode) == ""){
        		 results.push(new ValidationResult(true, 
	                    "settlementMode", "settlementModeMissing", 
Application.application.xResourceManager.getKeyValue('ref.ownsettlestanding.alert.validator.entry.settlemode')));
        	}
        	//If Diff Cash Is selected following are mandatory
        	if(value.diffCashSelected =="Y") {
        		if(value.cashSettlementBank == null || StringUtil.trim(value.cashSettlementBank) == ""){
        		 results.push(new ValidationResult(true, 
	                    "cashSettlementBank", "cashSettlementBankMissing", 
Application.application.xResourceManager.getKeyValue('ref.ownsettlestanding.alert.validator.entry.cashsettlebank')));
	                    
        		}
        		if(value.cashSettlementAccount == null || StringUtil.trim(value.cashSettlementAccount) == ""){
        		 results.push(new ValidationResult(true, 
	                    "cashSettlementAccount", "cashSettlementAccountMissing", 
Application.application.xResourceManager.getKeyValue('ref.ownsettlestanding.alert.validator.entry.cashsettleaccount')));
	                    
        		}
        		if(value.cashSettlementMode == null || StringUtil.trim(value.cashSettlementMode) == ""){
        		 results.push(new ValidationResult(true, 
	                    "cashSettlementMode", "cashSettlementModeMissing", 
Application.application.xResourceManager.getKeyValue('ref.ownsettlestanding.alert.validator.entry.cashsettlemode')));
        		}
        	}
        	
                    	
        	
        	return results;
        }
		
	}
}