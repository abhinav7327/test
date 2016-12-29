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
	public class BatchQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function BatchQueryValidator() {
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
 			
 			
 			//check batchStartDate is valid or not
        	if(value.batchStartDate != ""){
	            validDate1 = DateUtils.isValidDate(StringUtil.trim(value.batchStartDate)) ;            
	            if(!validDate1) {
	                results.push(new ValidationResult(true, 
	                    "batchStartDate", "illegalBatchStartDate", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.batchStartDate));
	               
	            }
        		
        	 }
        	 
        	return results;
        }
		
	}
}