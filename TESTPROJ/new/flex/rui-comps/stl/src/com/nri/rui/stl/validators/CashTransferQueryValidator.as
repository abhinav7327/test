// ActionScript file


package com.nri.rui.stl.validators {
	
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
    import mx.core.Application;
    
    /**
     * Custom Validator for Cash Transfer Query Implementation.
     * 
     */
	public class CashTransferQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function CashTransferQueryValidator() {
			super();
		}
		
		/**
         * 
         * validate
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
        	
        	if(value.valueDateFrom != null && StringUtil.trim(value.valueDateFrom).length!=0) {
	            var dateformat:CustomDateFormatter = new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString = "YYYYMMDD";
	            var formatData:String = "";
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDateFrom));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDateFrom))) {
	                results.push(new ValidationResult(true, 
	                    "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.illegaldateformat') 
	                    + value.valueDateFrom));
	            }
        	}
        	if(value.valueDateTo != null && StringUtil.trim(value.valueDateTo).length!=0) {
	            var dateformat:CustomDateFormatter = new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString = "YYYYMMDD";
	            var formatData:String = "";
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDateTo));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDateTo))) {
	                results.push(new ValidationResult(true, 
	                    "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.validate.illegaldateformat') 
	                    + value.valueDateTo));
	            }
        	}
        	return results;
        }
		
	}
}