// ActionScript file


package com.nri.rui.exm.validators
{
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
   
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */
	public class ExmQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function ExmQueryValidator() {
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
 		
 			var validDate1:Boolean = false;
 			var validDate2:Boolean = false;
 			var compareResult:Number = 1;
 			
 			//check baseDateFromStr is valid or not
        	if(value.baseDateFromStr != ""){
	            validDate1 = DateUtils.isValidDate(StringUtil.trim(value.baseDateFromStr)) ;            
	            if(!validDate1) {
	                results.push(new ValidationResult(true, 
	                    "baseDateFromStr", "illegalBaseDateFromStr", "Illegal date format " + value.baseDateFromStr));
	               
	            }
        		
        	 }
        	 
        	 //check baseDateToStr is valid or not
        	if(value.baseDateToStr != ""){
	             validDate2 = DateUtils.isValidDate(StringUtil.trim(value.baseDateToStr));           
	            if(!validDate2) {
	                results.push(new ValidationResult(true, 
	                    "baseDateToStr", "illegalBaseDateToStr", "Illegal date format " + value.baseDateToStr));
	               
	            }
        		
        	 }
        	
        	// check baseDateFromStr and baseDateToStr range is valid or not
        	if(value.baseDateFromStr != "" && value.baseDateToStr != "" && validDate1 && validDate2){
        		compareResult = DateUtils.compareDates (value.baseDateFromStr, value.baseDateToStr);
        		if(compareResult == 1){
        			 results.push(new ValidationResult(true, 
	                    "baseDateFromStr", "invalidBaseDateFromStr", "Invalid Date Range Specified "));
        		}
        	}
        	 
        	return results;
        }
		
	}
}