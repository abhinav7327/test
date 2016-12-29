
package com.nri.rui.ncm.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.ObjectUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class AdjustmentQueryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results : Array;
        
		public function AdjustmentQueryValidator()
		{
			super();
		}
		 /**
         * validate movement query form
         */ 
        protected override function doValidation(value : Object) : Array
        {
        	if (value == null) {
                XenosAlert.info("value object is null");
                return null;
            }
            
            var toDate:String =value.toDate;
            var fromDate:String =value.fromDate;
            var entryDateTo:String = value.entryDateTo;
            var entryDateFrom:String = value.entryDateFrom;
            var updateDateTo:String = value.updateDateTo;
            var updateDateFrom:String = value.updateDateFrom;
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;
            
            // Check toDate and fromDate  field.           
            if (XenosStringUtils.isBlank(toDate) || XenosStringUtils.isBlank(fromDate)) {
                results.push(new ValidationResult(true, 
                    "", "notoandfromDate", Application.application.xResourceManager.getKeyValue('ncm.prompt.adjustment.date.fromto')));
                return results;
            }
             
            // Check to & Form Date Format.            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            var fromDateObj:Date = null;
            var toDateObj:Date=null;
            
            if(DateUtils.isValidDate(fromDate)){
                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(fromDate));
            }else{
                results.push(new ValidationResult(true, 
                            "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('ncm.prompt.adjustment.date.from'))); 
            }
            
            if(DateUtils.isValidDate(toDate)){
                toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(toDate));
            }else{
                results.push(new ValidationResult(true, 
                            "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('ncm.prompt.adjustment.date.to'))); 
            }
           
            // Return if there are errors for the fromDate or toDate.
            if (results.length > 0)
                return results;
            
            var comDate:int=ObjectUtil.dateCompare(fromDateObj,toDateObj);
            // check Form Date not less than To Date
            if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('ncm.prompt.adjustment.date.lessto')));
            }

			// Entry Date Validation
			if (!XenosStringUtils.isBlank(entryDateTo)) {
	            if(DateUtils.isValidDate(entryDateFrom)){
	                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(entryDateFrom));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "entryDateFrom", "invalidFromDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.entry.date.from'))); 
	            }
	  		}
	        if (!XenosStringUtils.isBlank(entryDateFrom)) {
	            if(DateUtils.isValidDate(entryDateTo)){
	                toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(entryDateTo));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "entryDateTo", "invalidToDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.entry.date.to'))); 
	            }
	  		}
            // Update Date Validation
            if (!XenosStringUtils.isBlank(updateDateTo)) {
	            if(DateUtils.isValidDate(updateDateFrom)){
	                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(updateDateFrom));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "updateDateFrom", "invalidFromDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.update.date.from'))); 
	            }
	        }
	        if (!XenosStringUtils.isBlank(updateDateFrom)) {
	            if(DateUtils.isValidDate(updateDateTo)){
	                toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(updateDateTo));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "updateDateTo", "invalidToDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.update.date.to'))); 
	            }
            }
            
            return results;     
        } 
        
	}
}