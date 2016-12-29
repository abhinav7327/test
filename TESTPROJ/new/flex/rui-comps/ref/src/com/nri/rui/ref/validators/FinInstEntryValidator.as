
package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class FinInstEntryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;

		public function FinInstEntryValidator()
		{
			super();
		}
		/**
         * 
         * validate movement query form
         */ 
       
        protected override function doValidation(value:Object):Array {
        	
        	var countryCode:String = value.countryCode;
            var defaultOfficialName1:String = value.defaultOfficialName1;
            var defaultShortName:String = value.defaultShortName;
            var refListValueArray:Array = value.refListValueArray;
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
            
            if (XenosStringUtils.isBlank(countryCode)) {
                results.push(new ValidationResult(true, 
                    "countryCode", "countryCode", Application.application.xResourceManager.getKeyValue('ref.fininst.alert.validator.entry.countrycode')));
            } 
            if (XenosStringUtils.isBlank(defaultOfficialName1)) {
                results.push(new ValidationResult(true, 
                    "defaultOfficialName1", "defaultOfficialName1", Application.application.xResourceManager.getKeyValue('ref.fininst.alert.validator.entry.defaultofficename')));
            }  
            if (XenosStringUtils.isBlank(defaultShortName)) {
                results.push(new ValidationResult(true, 
                    "defaultShortName", "defaultShortName", Application.application.xResourceManager.getKeyValue('ref.fininst.alert.validator.entry.defaultshortname')));
            } 
            if(refListValueArray.length == 0){
            	results.push(new ValidationResult(true, 
                    "roleDef", "roleDef", Application.application.xResourceManager.getKeyValue('ref.fininst.alert.validator.entry.roledefinition')));
            }
            if(refListValueArray.length == 1){
            	//trace("validator.."+refListValueArray.length+" : <"+refListValueArray[0]);
              	if(XenosStringUtils.isBlank(refListValueArray[0])){
              		results.push(new ValidationResult(true, 
                    "roleDef", "roleDef", Application.application.xResourceManager.getKeyValue('ref.fininst.alert.validator.entry.roledefinition')));
              	}
            }
            return results;     
        }
	}
}