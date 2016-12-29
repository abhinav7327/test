

package com.nri.rui.drv.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class DrvUnrealizedPLValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        
		public function DrvUnrealizedPLValidator()
		{
			super();
		}
		
		/**
         * 
         * validate Drv UnrealizedPL query form
         */       
        protected override function doValidation(value:Object):Array{
        	if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('drv.alert.value.object.null'));
                return null;
            }
            
            var baseDate:String =value.baseDate;
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;
                
            if (XenosStringUtils.isBlank(baseDate)){
            	results.push(new ValidationResult(true, 
                    "baseDate", "noBaseDate", Application.application.xResourceManager.getKeyValue('drv.validator.enter.basedate')));
                return results;
            } 
            // Check to & Form Date Format.            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            var fromDateObj:Date = null;
            
            if(DateUtils.isValidDate(baseDate)){
                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(baseDate));
            }else{
                results.push(new ValidationResult(true, 
                            "baseDate", "invalidBaseDate", Application.application.xResourceManager.getKeyValue('drv.validator.invalid.basedate'))); 
            }
            
           
            return results;   
        }
		
	}
}