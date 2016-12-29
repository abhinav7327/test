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
	public class MarketPriceQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function MarketPriceQueryValidator() {
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
        	
        	//XenosAlert.info("Length="+String(StringUtil.trim(value.salesRole)).length);
        	
 /*       	if((value.officeIdList is Object) || String(StringUtil.trim(value.officeIdList)).length != 2) {
        		results.push(new ValidationResult(true,"", "officeId", "Office Id Cannot Be Blank."));
	            return results;
        	}
        	
        	if((value.salesRole is Object) || String(StringUtil.trim(value.salesRole)).length == 15) {
        		results.push(new ValidationResult(true,"", "salesId", "Sales Id Cannot Be Blank."));
	            return results;
        	}*/
        	
        	var dateList:Array = [];
        	
        	if(value.baseDate != ""){
	            var dateformat:CustomDateFormatter =new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString="YYYYMMDD";
	            var formatData:String ="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.baseDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.baseDate))) {
	                
	                results.push(new ValidationResult(true, 
	                    "baseDate", "illegalBaseDate", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.baseDate));
	                //return results;
	            }
        		
        	}
                    	
        	
        	return results;
        }
		
	}
}