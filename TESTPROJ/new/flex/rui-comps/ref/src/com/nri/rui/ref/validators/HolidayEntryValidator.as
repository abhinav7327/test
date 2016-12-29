package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.controls.DateField;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class HolidayEntryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        
		public function HolidayEntryValidator()
		{
			super();
		}
		
		/**
         * 
         * validate Holiday Entry form
         */ 
       
        protected override function doValidation(value:Object):Array {
        	
        	// Clear results Array.
            results = [];
            var calId:String = "";
            var holidayName:String = "";
            var holidayDate:String = "";
            if(value!=null){
            	try
	            	{
		            	calId=StringUtil.trim(value['calendar.calendarId']);
		            	holidayName = StringUtil.trim(value['calendar.holidayName']);
		            	holidayDate=StringUtil.trim(value['calendar.holidayDate']); 
	            	}
	            	catch(e:Error){
	            		trace(e);
	            	}
            }
            if (XenosStringUtils.isBlank(calId)){
            	results.push(new ValidationResult(true, 
                    "calId", "nocalId", Application.application.xResourceManager.getKeyValue('ref.holiday.alert.validator.entry.calendarid')));
			}
			if (XenosStringUtils.isBlank(holidayName)){
            	results.push(new ValidationResult(true, 
                    "holidayName", "noholidayName", Application.application.xResourceManager.getKeyValue('ref.holiday.alert.validator.entry.holidayname')));
			}
			
			if (XenosStringUtils.isBlank(holidayDate)){
            	results.push(new ValidationResult(true, 
                    "holidayDate", "noholidayDate", Application.application.xResourceManager.getKeyValue('ref.holiday.alert.validator.entry.holidaydate')));
			}
			else if (!DateUtils.isValidDate(holidayDate)){
            	results.push(new ValidationResult(true, 
                    "holidayDate", "noholidayDate", Application.application.xResourceManager.getKeyValue('ref.holiday.alert.validator.entry.holidaydateformat')));
			}
			
			return results;
        }
		
	}
}