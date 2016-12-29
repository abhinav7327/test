
package com.nri.rui.ref.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
	
	/**
     * Custom Validator for Stl Completion Summary Implementation.
     * 
     */
	public class EmployeeQueryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        
		public function EmployeeQueryValidator()
		{
			super();
		}
		/**
         * 
         * validate Completion summary form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
			if(value == null){
                XenosAlert.info("value object is null");
                return null;
            }
            
            var defaultOffice:String=value.defaultOffice;
            var dateformat:CustomDateFormatter;
            var formatData:String ="";
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
            
            // Check office  field.
            if (XenosStringUtils.isBlank(defaultOffice)) {
                results.push(new ValidationResult(true, 
                    "officeIdList", "officeIdList", Application.application.xResourceManager.getKeyValue('ref.employee.alert.validator.query.defaultoffice')));
            }
            
            if(value.logDate != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.logDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.logDate))) {
	                results.push(new ValidationResult(true, 
	                    "logDate", "illegalLogDate", Application.application.xResourceManager.getKeyValue('ref.employee.alert.validator.query.lastaccessdateformat')+" " + value.logDate));
	            }
        	}
        	if(value.startDate != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.startDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.startDate))) {
	                results.push(new ValidationResult(true, 
	                    "startDate", "illegalStartDate", Application.application.xResourceManager.getKeyValue('ref.employee.alert.validator.query.startdateformat')+" " + value.startDate));
	            }
        	}
            return results;  
		}
	}	
}