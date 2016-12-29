// ActionScript file


package com.nri.rui.stl.validators {
	
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
	public class BankTransferEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function BankTransferEntryValidator() {
			super();
		}
		
		/**
         * 
         * validate bank transfer entry form
         */ 
       
        protected override function doValidation(value:Object):Array {
        	
        	
        	
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
        	var dateList:Array = [];
        	
        	if(value.fromBankAccount == null || StringUtil.trim(value.fromBankAccount) == "") {
        		results.push(new ValidationResult(true, 
	                    "fromBankAccount", "fromBankAccountMissing", Application.application.xResourceManager.getKeyValue('stl.label.banktransfer.entry.validate.frombankaccount')));
        	}
        	if(value.toBankAccount == null || StringUtil.trim(value.toBankAccount) == "") {
        		results.push(new ValidationResult(true, 
	                    "toBankAccount", "toBankAccountMissing", Application.application.xResourceManager.getKeyValue('stl.label.banktransfer.entry.validate.tobankaccount')));
        	}
            if(value.securityCode == null || StringUtil.trim(value.securityCode) == "") {
        		 results.push(new ValidationResult(true, 
	                    "securityCode", "securityCodeMissing", Application.application.xResourceManager.getKeyValue('stl.label.banktransfer.entry.validate.securitycode')));
        	}
        	if(value.quantity == null || StringUtil.trim(value.quantity) == "") {
        		 results.push(new ValidationResult(true, 
	                    "quantity", "quantityMissing", Application.application.xResourceManager.getKeyValue('stl.label.banktransfer.entry.validate.quantity')));
        	}
        	/*if(isNaN(value.quantity)) {
        		 results.push(new ValidationResult(true, 
	                    "quantity", "quantityNumeric", "Quantity should be a Number"));
        	}*/
        	if(value.transmissionRequired == null || StringUtil.trim(value.transmissionRequired) == "") {
        		 results.push(new ValidationResult(true, 
	                    "transmissionRequired", "transmissionRequiredMissing", Application.application.xResourceManager.getKeyValue('stl.label.banktransfer.entry.validate.transmissionrequired')));
        	}
        	if(value.valueDate != null && StringUtil.trim(value.valueDate).length!=0) {
	            var dateformat:CustomDateFormatter = new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString = "YYYYMMDD";
	            var formatData:String = "";
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDate))) {
	                results.push(new ValidationResult(true, 
	                    "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('stl.label.banktransfer.entry.validate.illegaldateformat') + value.valueDate));
	            }
        	}
        	if(!(value.fromBankAccount == null || StringUtil.trim(value.fromBankAccount) == "") 
        		&& !(value.toBankAccount == null || StringUtil.trim(value.toBankAccount) == "")) {
        			
        		if(value.fromBankAccount == value.toBankAccount) {
	        		results.push(new ValidationResult(true, 
		                    "fromToBankAccount", "fromToBankAccountSame", Application.application.xResourceManager.getKeyValue('stl.label.banktransfer.entry.validate.frombankaccounttobankaccount')));
        		}
        	}
        	
        	return results;
        }
		
	}
}