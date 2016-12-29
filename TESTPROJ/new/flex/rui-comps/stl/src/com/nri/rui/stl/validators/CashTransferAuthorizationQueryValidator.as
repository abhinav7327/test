

package com.nri.rui.stl.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.ObjectUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class CashTransferAuthorizationQueryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results : Array;
        
		public function CashTransferAuthorizationQueryValidator()
		{
			super();
		}
		 /**
         * validate movement query form
         */ 
        protected override function doValidation(value : Object) : Array
        {
        	if (value == null) {
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.label.settlement.query.validate.valueobject'));
                return null;
            }
            
            var valueToDate:String = value.valueToDate;
            var valueFromDate:String = value.valueFromDate;
                        
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;
            
             
            // Check to & Form Date Format.            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            var fromDateObj:Date = null;
            var toDateObj:Date=null;
            
            if(!XenosStringUtils.isBlank(valueFromDate)){
            	if (DateUtils.isValidDate(valueFromDate)){
                	fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valueFromDate));
            	}else{
                	results.push(new ValidationResult(true, 
                            "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('stl.error.prompt.date.from'))); 
            	}
            }
            if(!XenosStringUtils.isBlank(valueToDate)){
	            if(DateUtils.isValidDate(valueToDate)){
    	            toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valueToDate));
        	    }else{
            	    results.push(new ValidationResult(true, 
                            "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('stl.error.prompt.date.to'))); 
            	}
            }           
            // Return if there are errors for the fromDate or toDate.
            if (results.length > 0)
                return results;
           if (XenosStringUtils.isBlank(valueToDate) || XenosStringUtils.isBlank(valueFromDate)) {
           		return results;
           }
            var comDate:int=ObjectUtil.dateCompare(fromDateObj,toDateObj);
            // check Form Date not less than To Date
            if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('stl.error.prompt.date.fromlessto')));
            }
            // 
            
            return results;     
        } 
        
	}
}