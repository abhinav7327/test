// ActionScript file


package com.nri.rui.ref.validators
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
   
    
    /**
     * Custom Validator for Employee Entry
     * 
     */
	public class EmployeeEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function EmployeeEntryValidator() {
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
        
        	if(value.mode == "entry"){
	        	//User Id
	        	if(value.userId == null || StringUtil.trim(value.userId) == ""){
	        		 results.push(new ValidationResult(true, 
		                    "userId", "userIdMissing", Application.application.xResourceManager.getKeyValue('ref.employee.alert.validator.entry.useridmissing')));
	        	}
	        }
	        if(value.mode == "entry"
	        	|| value.mode == "amend" ){
		        	//First Name
		        	if(value.firstName == null || StringUtil.trim(value.firstName) == ""){
		        		 results.push(new ValidationResult(true, 
			                    "firstName", "firstNameMissing", Application.application.xResourceManager.getKeyValue('ref.employee.alert.validator.entry.firstnamemissing')));
		        	}
		        	//Last Name
		        	if(value.lastName == null || StringUtil.trim(value.lastName) == ""){
		        		 results.push(new ValidationResult(true, 
			                    "lastName", "lastNameMissing", Application.application.xResourceManager.getKeyValue('ref.employee.alert.validator.entry.lastnamemissing')));
		        	}
	        	}
        	if(value.mode == "entry"){
	        	//Start Date
	        	var dateList:Array = [];
	        	if(value.startDate != ""){
		            var dateformat:CustomDateFormatter =new CustomDateFormatter();
		            //format of the date
		            dateformat.formatString="YYYYMMDD";
		            var formatData:String ="";	            
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.startDate));
		            if(!DateUtils.isValidDate(StringUtil.trim(value.startDate))) {
		                results.push(new ValidationResult(true, 
		                    "startDate", "illegalStartDate", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.startDate));
		                //return results;
		            }
	        		
	        	}else{
	        	results.push(new ValidationResult(true, 
		                    "startDate", "startDateMissing", Application.application.xResourceManager.getKeyValue('ref.employee.alert.validator.entry.startdate')));
	        	}
        	}
        	if( (value.mode == Globals.MODE_AMEND && value.restrictPermission == "Y")
        			|| value.mode == Globals.MODE_ENTRY ){
        			
        		if( Globals.EMPTY_STRING != value.rePasswd
        		    	|| Globals.EMPTY_STRING != value.passwd
        		    	|| value.mode == Globals.MODE_ENTRY ){
	        		//Password
		        	if(value.passwd == null || value.passwd == ""){
		        		 results.push(new ValidationResult(true, 
			                    "passwd", "passwdMissing", Application.application.xResourceManager.getKeyValue('ref.employee.alert.validator.entry.initialpass')));
		        	}
		        	//Re Type Password
		        	if(value.rePasswd == null || value.rePasswd == ""){
		        		 results.push(new ValidationResult(true, 
			                    "rePasswd", "rePasswdMissing", Application.application.xResourceManager.getKeyValue('ref.employee.alert.validator.entry.retypeinitialpass')));
		        	}		
	        	}
        	}
        	
        	if(value.mode == "cancel"){
        		XenosAlert.info(value.uhistoryReasion);
        		//uhistoryReasion
        		if(value.uhistoryReasion == null || StringUtil.trim(value.uhistoryReasion) == ""){
	        		 results.push(new ValidationResult(true,
		                    "uhistoryReasion", "uhistoryReasiondMissing", Application.application.xResourceManager.getKeyValue('ref.employee.alert.validator.entry.historyreason')));
	        	}
        	}
        	
        	
        	
        	return results;
        }
		
	}
}