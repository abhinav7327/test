// ActionScript file


package com.nri.rui.ref.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import mx.utils.ObjectUtil;
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;   
    
    /**
     * Custom Validator for Swift Message Search
     * 
     */
	public class SwiftMessageSearchValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function SwiftMessageSearchValidator() {
			super();
		}
		
		/**
         * 
         * Validate swift message search query form
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
        	var receiveFromDt:Date = null;
        	if(value.receiveDateFrom == null || StringUtil.trim(value.receiveDateFrom) == "") {
        	   //receive date from is mandatory       		
	           results.push(new ValidationResult(true, 
	           		"receiveDateFrom", "emptyreceiveDateFrom", Application.application.xResourceManager.getKeyValue('ref.missing.receivedatefrom')));
        	} else {
        	   var dateformat:CustomDateFormatter = new CustomDateFormatter();
	           //format of the date
	           dateformat.formatString="YYYYMMDD";

	           if(!DateUtils.isValidDate(StringUtil.trim(value.receiveDateFrom))) {
	               results.push(new ValidationResult(true, 
	                    "receiveDateFrom", "receiveDateFrom", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat') + value.receiveDateFrom));
	            }else{
	            	receiveFromDt = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.receiveDateFrom));
	            }
        	}
        	
        	var receiveToDt:Date = null;
        	if(value.receiveDateTo == null || StringUtil.trim(value.receiveDateTo) == "") {
        	   //receive date to is mandatory       		
	           results.push(new ValidationResult(true, 
	           		"receiveDateTo", "emptyreceiveDateTo", Application.application.xResourceManager.getKeyValue('ref.missing.receivedateto')));
        	} else {
        	   var dateformat1:CustomDateFormatter = new CustomDateFormatter();
	           //format of the date
	           dateformat1.formatString="YYYYMMDD";
	            
	           if(!DateUtils.isValidDate(StringUtil.trim(value.receiveDateTo))) {
	               results.push(new ValidationResult(true, 
	                    "receiveDateTo", "receiveDateTo", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat') + value.receiveDateTo));
	            }else{
	            	receiveToDt = dateformat1.toDate(CustomDateFormatter.customizedInputDateString(value.receiveDateTo));
	            }
        	}
        	if(receiveToDt!=null && receiveFromDt!=null){
        		if(ObjectUtil.dateCompare(receiveFromDt,receiveToDt) == 1){
	        		results.push(new ValidationResult(true, 
	                    "", "toDateThanFromDate",  Application.application.xResourceManager.getKeyValue('ref.invalid.date.combination')));
	        	}
        	}
        	return results;
        }
	}
}