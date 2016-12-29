// ActionScript file


package com.nri.rui.drv.validators
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */
	public class DrvTradeDetailsValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function DrvTradeDetailsValidator() {
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
                
            // Validate Security Code    
        	if(value.securityId == null || StringUtil.trim(value.securityId) == ""){
        		 results.push(new ValidationResult(true, 
	                    "securityCode", "securityCodeMissing",Application.application.xResourceManager.getKeyValue('drv.validator.missing.seccode')));
        	}
        	
        	// Validate Open Close Flag
        	if(value.openClosePosition == null || StringUtil.trim(value.openClosePosition) == ""){
        		 results.push(new ValidationResult(true, 
	                    "openClosePosition", "openClosePositionMissing", Application.application.xResourceManager.getKeyValue('drv.validator.missing.openclose')));
        	}
        	
        	// Validate the Trade Date
        	if(value.tradeDate != ""){
	            var dateformat:CustomDateFormatter =new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString="YYYYMMDD";
	            var formatData:String ="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.tradeDate))) {
	                
	                results.push(new ValidationResult(true, 
	                    "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('drv.validator.illegal.dateformat') + value.tradeDate));
	                //return results;
	            }
        		
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "tradeDate", "tradeDateMissing", Application.application.xResourceManager.getKeyValue('drv.validator.missing.tradedate')));
        	}
        	
        	// Validate Fund Account No
        	if(value.fundAccountNo == null || StringUtil.trim(value.fundAccountNo) == ""){
        		 results.push(new ValidationResult(true, 
	                    "fundAccountNo", "fundAccountNoMissing",Application.application.xResourceManager.getKeyValue('drv.validator.missing.fundacc')));
        	}
        	
        	// Validate Execution Broker Account No
        	if(value.exeBrkAccountNo == null || StringUtil.trim(value.exeBrkAccountNo) == ""){
        		 results.push(new ValidationResult(true, 
	                    "exeBrkAccountNo", "exeBrkAccountNoMissing", Application.application.xResourceManager.getKeyValue('drv.validator.missing.exebrokeracc')));
        	}
        	
        	// Validate Broker Account No
        	if(value.brkAccountNo == null || StringUtil.trim(value.brkAccountNo) == ""){
        		 results.push(new ValidationResult(true, 
	                    "brkAccountNo", "brkAccountNoMissing", Application.application.xResourceManager.getKeyValue('drv.validator.missing.brokeracc')));
        	}
			
			// Validate Price
        	if(value.price == null || StringUtil.trim(value.price) == ""){
        		 results.push(new ValidationResult(true, 
	                    "price", "priceMissing", Application.application.xResourceManager.getKeyValue('drv.validator.missing.price')));
        	}
			
			// Validate Quantity
        	if(value.quantity == null || StringUtil.trim(value.quantity) == ""){
        		 results.push(new ValidationResult(true, 
	                    "quantity", "quantityMissing", Application.application.xResourceManager.getKeyValue('drv.validator.missing.qty')));
        	}                    	
        	
        	return results;
        }
		
	}
}