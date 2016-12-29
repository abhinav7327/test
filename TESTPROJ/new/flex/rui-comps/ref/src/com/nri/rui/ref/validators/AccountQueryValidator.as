// ActionScript file


package com.nri.rui.ref.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
   
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */
	public class AccountQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function AccountQueryValidator() {
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
        	
        	//XenosAlert.info("Length="+String(StringUtil.trim(value.salesRole)).length);
        	
 /*       	if((value.officeIdList is Object) && String(StringUtil.trim(value.officeIdList)).length != 2) {
        		results.push(new ValidationResult(true,"", "officeId", "Office Id Cannot Be Blank."));
	            return results;
        	}
        	
        	if((value.salesRole is Object) && String(StringUtil.trim(value.salesRole)).length == 15) {
        		results.push(new ValidationResult(true,"", "salesId", "Sales Id Cannot Be Blank."));
	            return results;
        	}*/
        	
        	var dateList:Array = [];
        	
        	if(value.openDateFrom != "")
        		dateList.push(value.openDateFrom);
            
            if(value.openDateTo != "")
            	dateList.push(value.openDateTo);
            
            if(value.closeDateFrom != "")
            	dateList.push(value.closeDateFrom);
            
            if(value.closeDateTo != "")
            	dateList.push(value.closeDateTo);
        	
        	
        	var flag:int=0;
            
            
            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            //format of the date
            dateformat.formatString="YYYYMMDD";
            var formatData:String ="";
            
            var dateObj:Array = [];
            
            for(var iterator:int=0; iterator<dateList.length; iterator++) {
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
	            
	            if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator]))) {
	            	
	            	dateObj[iterator] = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
	             
	            } else {
	                
	                results.push(new ValidationResult(true, 
	                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + dateList[iterator]));
	                return results;
	            }
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2) {
            	var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check From Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.query.fromtodatecomp')));
	            }
            }
        	
        	
        	return results;
        }
		
	}
}