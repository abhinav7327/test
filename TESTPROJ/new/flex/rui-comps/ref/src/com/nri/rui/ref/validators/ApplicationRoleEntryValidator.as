package com.nri.rui.ref.validators
{
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class ApplicationRoleEntryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        
		public function ApplicationRoleEntryValidator()
		{
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
        	
        	
        	
        	if(value.appRoleName == null || StringUtil.trim(value.appRoleName) == ""){
        		 results.push(new ValidationResult(true, 
	                    "appRoleName", "appRoleNameMissing", Application.application.xResourceManager.getKeyValue('ref.approle.alert.validator.query.approlename')));
        	}
        	if(value.officeIdStr == null || StringUtil.trim(value.officeIdStr) == ""){
        		 results.push(new ValidationResult(true, 
	                    "officeIdStr", "officeIdStrMissing", Application.application.xResourceManager.getKeyValue('ref.approle.alert.validator.query.officeid')));
        	}
        	if(value.acRestrictionValue == null || StringUtil.trim(value.acRestrictionValue) == ""){
        		 results.push(new ValidationResult(true, 
	                    "acRestrictionValue", "acRestrictionValueMissing", Application.application.xResourceManager.getKeyValue('ref.approle.alert.validator.query.acrestrictionvalue')));
        	}      	
        	
        	return results;
        }
	}
}