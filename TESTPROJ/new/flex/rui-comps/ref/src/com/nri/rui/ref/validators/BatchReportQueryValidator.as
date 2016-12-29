package com.nri.rui.ref.validators
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
	
	/**
     * Custom Validator for Batch Report Query Implementation.
     * 
     */

	public class BatchReportQueryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        
        // constructor
		public function BatchReportQueryValidator()
		{
			super();
		}
		
		/**
         * 
         * validate movement query form
         */ 
       
        protected override function doValidation(value:Object):Array {
   
            var toDate:String =value.toDate;
            var fromDate:String =value.fromDate;
            
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
            var formatData:String ="";
            
//            ****
//              // Check to & Form Date Format.   
           
           if (XenosStringUtils.isBlank(toDate) && !XenosStringUtils.isBlank(fromDate)) {
                results.push(new ValidationResult(true, 
                    "", "notoandfromDate", Application.application.xResourceManager.getKeyValue('ref.batchreport.alert.validator.query.nofromandto')));
                return results;
            }   
                  
           if (!XenosStringUtils.isBlank(toDate) && XenosStringUtils.isBlank(fromDate)) {
                results.push(new ValidationResult(true, 
                    "", "notoandfromDate", Application.application.xResourceManager.getKeyValue('ref.batchreport.alert.validator.query.nofromandto')));
                return results;
            }
           if (!XenosStringUtils.isBlank(toDate) && !XenosStringUtils.isBlank(fromDate)) {
 				 
 				 var fromDateObj:Date = null; 
				 if(DateUtils.isValidDate(fromDate)){
                	fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(fromDate));
            	 }else{
                	results.push(new ValidationResult(true, 
                    	        "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('ref.batchreport.alert.validator.query.fromdate'))); 
            	 }
   				
            	var toDateObj:Date=null;
               	if(DateUtils.isValidDate(value.toDate)){
                	toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.toDate));
            	}else{
                	results.push(new ValidationResult(true, 
                    	        "toDate", "invalidToDate",Application.application.xResourceManager.getKeyValue('ref.batchreport.alert.validator.query.todate'))); 
            	}
            	
           
            // Return if there are errors for the fromDate or toDate.
            	if (results.length > 0)
                	return results;
            
            var comDate:int=ObjectUtil.dateCompare(fromDateObj,toDateObj);
           // check Form Date not less than To Date
            	if (comDate==1) {
                	results.push(new ValidationResult(true, 
                    	 "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('ref.batchreport.alert.validator.query.fromdatelessthanto')));
            	}
         }
       	
        	return results;
      }
		
	}
}