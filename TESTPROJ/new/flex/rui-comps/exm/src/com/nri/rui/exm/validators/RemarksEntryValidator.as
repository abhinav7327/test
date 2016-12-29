// ActionScript file


package com.nri.rui.exm.validators
{
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
   
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */
	public class RemarksEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function RemarksEntryValidator() {
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
 			
 			if(XenosStringUtils.isBlank(value.userComment)){
 			    results.push(new ValidationResult(true, 
	                    "emptyRemarks", "emptyRemarks", "Please enter User Comment."));
	            return results;        
 			}else if(value.userComment.length > 200){
 			    results.push(new ValidationResult(true, 
	                    "overflowedRemarks", "overflowedRemarks", "User Comment is too large."));
 			}
 			
 			if(!XenosStringUtils.isBlank(value.assignTo) && value.assignTo.length > 35 ){
 			    results.push(new ValidationResult(true, 
	                    "overflowedAssignTo", "overflowedAssignTo", "Assign To value is too large."));	                  
 			}
 			
        	 
        	return results;
        }
		
	}
}