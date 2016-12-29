
package com.nri.rui.ref.validators
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.ObjectUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class FinInstQueryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        
		public function FinInstQueryValidator()
		{
			super();
		}
		/**
         * 
         * validate movement query form
         */ 
       
        protected override function doValidation(value:Object):Array {
        	
        	var toDate:String =value.closedToDate;
            var fromDate:String =value.closedFromDate;
            
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
        	var dateformat:CustomDateFormatter =new CustomDateFormatter();
            //format of the date
            dateformat.formatString="YYYYMMDD";
                        
           if (!XenosStringUtils.isBlank(toDate) && !XenosStringUtils.isBlank(fromDate)) {
 				 
 				 var fromDateObj:Date = null; 
				 if(DateUtils.isValidDate(fromDate)){
                	fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(fromDate));
            	 }else{
                	results.push(new ValidationResult(true, 
                    	        "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('ref.fininst.alert.validator.invalidfromdate'))); 
            	 }
   				
            	var toDateObj:Date=null;
               	if(DateUtils.isValidDate(toDate)){
                	toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(toDate));
            	}else{
                	results.push(new ValidationResult(true, 
                    	        "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('ref.fininst.alert.validator.invalidtodate'))); 
            	}
            	
           
            // Return if there are errors for the fromDate or toDate.
            	if (results.length > 0)
                	return results;
            
            var comDate:int=ObjectUtil.dateCompare(fromDateObj,toDateObj);
            // check Form Date not less than To Date
        	if (comDate==1) {
            	results.push(new ValidationResult(true, 
                	 "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('ref.fininst.alert.validator.invalidfromtorange')));
        	}
          }
          
          return results;
        }
	}
}