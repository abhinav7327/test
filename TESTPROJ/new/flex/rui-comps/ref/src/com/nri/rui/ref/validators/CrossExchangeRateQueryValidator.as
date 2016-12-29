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
     * Custom Validator for Cross Query Implementation.
     * 
     */
	public class CrossExchangeRateQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function CrossExchangeRateQueryValidator() {
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
        	
        	
        	var dateList:Array = [];
        	
        	if(value.baseDateFromStr != ""){
	            var dateformat:CustomDateFormatter =new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString="YYYYMMDD";
	            var formatData:String ="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.baseDateFromStr));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.baseDateFromStr))) {
	                
	                results.push(new ValidationResult(true, 
	                    "baseDateFromStr", "illegalbaseDateFromStr", Application.application.xResourceManager.getKeyValue('ref.crossexchangerate.alert.validator.query.basedatefromnotvalid')));
	                //return results;
	            }
        		
        	}
        	
        	if(value.baseDateToStr != ""){
	            var dateformat:CustomDateFormatter =new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString="YYYYMMDD";
	            var formatData:String ="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.baseDateToStr));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.baseDateToStr))) {
	                
	                results.push(new ValidationResult(true, 
	                    "baseDateToStr", "illegalbaseDateToStr", Application.application.xResourceManager.getKeyValue('ref.crossexchangerate.alert.validator.query.basedatetonotvalid')));
	                //return results;
	            }
        		
        	}
        	        	
        	return results;
        }
		
	}
}