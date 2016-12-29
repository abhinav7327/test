// ActionScript file


package com.nri.rui.cax.validator
{
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	    
	/**
	 * Custom Validator for Trade Query Implementation.
	 * 
	 */
	public class StockRateEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
		private var results:Array;
		
		// constructor
		public function StockRateEntryValidator() {
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
			
        	
        	
        	if(value.mode == "rateentry") {
        		if(value.stockRate == null || StringUtil.trim(value.stockRate) == "") {
					results.push(new ValidationResult(true, 
						"stockRate", "stockRateMissing", Application.application.xResourceManager.getKeyValue('cax.empty.stock.rate')));
				} else {
					var formattedAmt:String = removeCommaFromString(value.stockRate);
					if(parseFloat(formattedAmt) == 0) {
						results.push(new ValidationResult(true, 
							"stockRate", "stockRateZero", Application.application.xResourceManager.getKeyValue('cax.stock.rate.zero.not.allowed')));
					}
				}
        	} else {
				if(value.stockRate != null && StringUtil.trim(value.stockRate) != "") {
					results.push(new ValidationResult(true, 
						"stockRate", "stockRatePresent", Application.application.xResourceManager.getKeyValue('cax.stock.rate.delete')));
				}
        	}
                    	
        	return results;
        }
        
		private function removeCommaFromString(amount:String):String {
			var amountStr:String = amount;
			var len:int = amountStr.length;
			var newString:String = "";
			
			var index:int;
			for(index = 0; index < len; index++ ) {
				if(amountStr.charAt(index)!= ',')
					newString = newString + amountStr.charAt(index);
			}
			return newString;
		}
		
	}
}