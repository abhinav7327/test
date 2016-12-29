// ActionScript file


package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
	
   
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */
	public class IntraReconQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function IntraReconQueryValidator() {
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
	                    "baseDateFromStr", "illegalBaseDateFromStr", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.baseDateFromStr));
	               
	            }
        		
        	 }
        	 
        	 //check baseDateToStr is valid or not
        	if(value.baseDateToStr != ""){
	             validDate2 = DateUtils.isValidDate(StringUtil.trim(value.baseDateToStr));           
	            if(!validDate2) {
	                results.push(new ValidationResult(true, 
	                    "baseDateToStr", "illegalBaseDateToStr", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.baseDateToStr));
	               
	            }
        		
        	 }
        	
        	// check baseDateFromStr and baseDateToStr range is valid or not
        	if(value.baseDateFromStr != "" && value.baseDateToStr != "" && validDate1 && validDate2){
        		compareResult = DateUtils.compareDates (value.baseDateFromStr, value.baseDateToStr);
        		if(compareResult == 1){
        			 results.push(new ValidationResult(true, 
	                    "baseDateFromStr", "invalidBaseDateFromStr", Application.application.xResourceManager.getKeyValue('ref.intrarecon.alert.validator.basedaterange')));
        		}
        	}
        	 
        	return results;
        }
		
	}
}