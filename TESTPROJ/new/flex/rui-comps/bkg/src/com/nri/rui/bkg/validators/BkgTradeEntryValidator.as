// ActionScript file


package com.nri.rui.bkg.validators
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    
    /**
     * Custom Validator for Banking Trade Entry Implementation.
     * 
     */
	public class BkgTradeEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function BkgTradeEntryValidator() {
			super();
		}
		
		/**
         * validate banking trade entry form
         */ 
        protected override function doValidation(value:Object):Array {
        	
        	// Clear results Array.
            results = [];
            var formatData:String ="";
            var dateformat:CustomDateFormatter = new CustomDateFormatter();

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
        	if(value.tradeDate != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.tradeDate))) {
	                
	                results.push(new ValidationResult(true, 
	                    "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('bkg.error.illegal.date') + value.tradeDate));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "tradeDate", "tradeDateMissing", Application.application.xResourceManager.getKeyValue('bkg.error.missing.tradedate')));
        	}
        	
        	if(value.startDate != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.startDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.startDate))) {
	                
	                results.push(new ValidationResult(true, 
	                    "startDate", "illegalStartDate", Application.application.xResourceManager.getKeyValue('bkg.error.illegal.date') + value.startDate));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "startDate", "startDateMissing", Application.application.xResourceManager.getKeyValue('bkg.error.missing.startdate')));
        	}
        	
        	if(value.maturityDate != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.maturityDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.maturityDate))) {
	                
	                results.push(new ValidationResult(true, 
	                    "maturityDate", "illegalMaturityDate", Application.application.xResourceManager.getKeyValue('bkg.error.illegal.date') + value.maturityDate));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "maturityDate", "maturityDateMissing", Application.application.xResourceManager.getKeyValue('bkg.error.missing.maturitydate')));
        	}
        	
        	if(value.tradeType == null || StringUtil.trim(value.tradeType) == ""){
        		 results.push(new ValidationResult(true, 
	                    "tradeType", "tradeTypeMissing", Application.application.xResourceManager.getKeyValue('bkg.error.missing.tradetype')));
        	}
        	
        	if(value.counterPartyAccountNo == null || StringUtil.trim(value.counterPartyAccountNo) == ""){
        		 results.push(new ValidationResult(true, 
	                    "counterPartyAccountNo", "counterPartyAccountNoMissing", Application.application.xResourceManager.getKeyValue('bkg.error.missing.cpaccountno')));
        	}
        	
        	if(value.fundAccountNo == null || StringUtil.trim(value.fundAccountNo) == ""){
        		 results.push(new ValidationResult(true, 
	                    "fundAccountNo", "fundAccountNoMissing", Application.application.xResourceManager.getKeyValue('bkg.error.missing.fundaccountno')));
        	}
        	
        	if(value.currencyCode == null || StringUtil.trim(value.currencyCode) == ""){
        		 results.push(new ValidationResult(true, 
	                    "currencyCode", "currencyCodeMissing", Application.application.xResourceManager.getKeyValue('bkg.error.missing.ccycode')));
        	}
        	
        	if(value.principalAmount == null || StringUtil.trim(value.principalAmount) == ""){
        		 results.push(new ValidationResult(true, 
	                    "principalAmount", "principalAmountMissing", Application.application.xResourceManager.getKeyValue('bkg.error.missing.prinamnt')));
        	}
        	
        	if(value.interestRate == null || StringUtil.trim(value.interestRate) == ""){
        		 results.push(new ValidationResult(true, 
	                    "interestRate", "interestRateMissing", Application.application.xResourceManager.getKeyValue('bkg.error.missing.intrrate')));
        	}
        	return results;
        }
		
	}
}