// ActionScript file


package com.nri.rui.frx.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;   
    
    /**
     * Custom Validator for Forex Revaluation Query Implementation.
     * 
     */
	public class FrxRvlQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function FrxRvlQueryValidator() {
			super();
		}
		
		/**
         * 
         * Validate forex revaluation query form
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
        	
        	if(value.bookingDate == null || StringUtil.trim(value.bookingDate) == "") {
        	   //base date is mandatory       		
	           results.push(new ValidationResult(true, 
	           		"baseDate", "emptyBaseDate", Application.application.xResourceManager.getKeyValue('frx.missing.basedate')));
        	} else {
        	   var dateformat:CustomDateFormatter = new CustomDateFormatter();
	           //format of the date
	           dateformat.formatString="YYYYMMDD";
	           var formatData:String ="";	            
	           formatData = dateformat.format(CustomDateFormatter.customizedInputDateString(value.bookingDate));
	            
	           if(!DateUtils.isValidDate(StringUtil.trim(value.bookingDate))) {
	               results.push(new ValidationResult(true, 
	                    "baseDate", "illegalBaseDate", Application.application.xResourceManager.getKeyValue('frx.error.illegal.date') + value.bookingDate));
	            }
        	}
        	return results;
        }
	}
}