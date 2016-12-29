// ActionScript file


package com.nri.rui.stl.validators {
	
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.controls.XenosAlert;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
    import mx.core.Application;
    
    /**
     * Custom Validator for Cash Transfer.
     * 
     */
	public class CashTransferEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;
        // Flag to determine the validation of BANK_TO_BANK or FIRM_PAYMENT/FIRM_RECEIPT
        private var validateFlag:String = null;

        // constructor
		public function CashTransferEntryValidator(vldtFlag:String) {
			super();
			this.validateFlag = vldtFlag;
		}
		
		/**
         * 
         * validate Cash Transfer Entry Form
         */ 
        protected override function doValidation(value:Object):Array {
        	
        	//XenosAlert.info("validateFlag : "+validateFlag);
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
 			var dateList:Array = [];			
 			
 			
 			if(value.fundCode == null || StringUtil.trim(value.fundCode) == "") {
        		results.push(new ValidationResult(true, 
	                    "fundCode", "fundCodeMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.fundcode')));
        	
        	
        	}
        	if(value.currency == null || StringUtil.trim(value.currency) == "") {
        		results.push(new ValidationResult(true, 
	                    "currency", "currencyMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.currency')));
        	}
 			if(validateFlag == 'Firm') {
 				if(value.cpAccountNo == null || StringUtil.trim(value.cpAccountNo) == "") {
	        		results.push(new ValidationResult(true, 
		                    "cpAccountNo", "cpAccountNoMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.cpaccountno')));
	        	}
 			}
 			if(value.wireAmount == null || StringUtil.trim(value.wireAmount) == "") {
        		results.push(new ValidationResult(true, 
	                    "wireAmount", "wireAmountMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.wireamount')));
        	}
        	if(value.valueDate == null || StringUtil.trim(value.valueDate) == "") {
        		results.push(new ValidationResult(true, 
	                    "valueDate", "valueDateMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.valuedate')));
        	}
        	if(value.valueDate != null && StringUtil.trim(value.valueDate).length!=0) {
	            var dateformat:CustomDateFormatter = new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString = "YYYYMMDD";
	            var formatData:String = "";
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDate))) {
	                results.push(new ValidationResult(true, 
	                    "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.illegaldateformat') 
	                    + value.valueDate));
	            }
        	}
        	if(validateFlag == 'Firm') {
	        	if(value.gleLedgerCode == null || StringUtil.trim(value.gleLedgerCode) == "") {
	        		results.push(new ValidationResult(true, 
		                    "gleLedgerCode", "gleLedgerCodeMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.gleledgercode')));
	        	}
	        	if(value.tradeDate != null && StringUtil.trim(value.tradeDate).length!=0) {
		            var dateformat:CustomDateFormatter = new CustomDateFormatter();
		            //format of the date
		            
		            dateformat.formatString = "YYYYMMDD";
		            var formatData:String = "";
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDate));
		            if(!DateUtils.isValidDate(StringUtil.trim(value.tradeDate))) {
		                results.push(new ValidationResult(true, 
		                    "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.illegaldateformat') 
		                    + value.tradeDate));
		            }
	        	}else {	        		
	        		results.push(new ValidationResult(true, 
		                    "tradeDate", "tradeDateMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.tradedate')));
	        		
	        	}
        	}
        	if(value.inxTransmission == null || StringUtil.trim(value.inxTransmission) == "") {
        		results.push(new ValidationResult(true, 
	                    "inxTransmission", "inxTransmissionMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.inxtransmission')));
        	}
        	if(validateFlag == 'Bank') {
	        	if(value.toBank == null || StringUtil.trim(value.toBank) == "") {
	        		results.push(new ValidationResult(true, 
		                    "toBank", "toBankMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.tobank')));
	        	}
	        	if(value.toSettleAccount == null || StringUtil.trim(value.toSettleAccount) == "") {
	        		results.push(new ValidationResult(true, 
		                    "toSettleAccount", "toSettleAccountMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.tosettleacount')));
	        	}
	        	if(value.fromBank == null || StringUtil.trim(value.fromBank) == "") {
	        		results.push(new ValidationResult(true, 
		                    "fromBank", "fromBankMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.frombank')));
	        	}
	        	if(value.fromSettleAccount == null || StringUtil.trim(value.fromSettleAccount) == "") {
	        		results.push(new ValidationResult(true, 
		                    "fromSettleAccount", "fromSettleAccountMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.fromsettleaccount')));
	        	}
	        	if(StringUtil.trim(value.fromSettleAccount) != "" 
	        				&& StringUtil.trim(value.toSettleAccount) != "") {
		        	if(value.fromSettleAccount == value.toSettleAccount) {
		        		results.push(new ValidationResult(true, 
			                    "fromToSettleAccount", "fromToSettleAccountSame", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.frombankaccounttobankaccount')));
		        	}
	        	}
        	}
        	if(validateFlag == 'Firm') {
        		if(value.ownBank == null || StringUtil.trim(value.ownBank) == "") {
	        		results.push(new ValidationResult(true, 
		                    "ownBank", "ownBankMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.ownbank')));
	        	}
	        	if(value.ownSettleAccount == null || StringUtil.trim(value.ownSettleAccount) == "") {
	        		results.push(new ValidationResult(true, 
		                    "ownSettleAccount", "ownSettleAccountMissing", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.ownsettleaccount')));
	        	}
        	}
       	   
        	return results;
        }
	}
}