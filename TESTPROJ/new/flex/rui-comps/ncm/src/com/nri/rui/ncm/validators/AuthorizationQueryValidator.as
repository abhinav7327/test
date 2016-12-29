
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

	public class AuthorizationQueryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results : Array;
        
		public function AuthorizationQueryValidator()
		{
			super();
		}
		 /**
         * validate movement query form
         */ 
        protected override function doValidation(value : Object) : Array
        {
        	if (value == null) {
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('ncm.prompt.object.null'));
                return null;
            }
            
            var toDate:String = value.toDate;
            var fromDate:String = value.fromDate;
            var ccyCode:String = value.ccyCode;            
            var instrumentId:String = value.instrumentId;
                        
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
                    "", "notoandfromDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.fromto')));
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
                            "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.from'))); 
            }
            
            if(DateUtils.isValidDate(toDate)){
                toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(toDate));
            }else{
                results.push(new ValidationResult(true, 
                            "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.to'))); 
            }
           
            // Return if there are errors for the fromDate or toDate.
            if (results.length > 0)
                return results;
            
            var comDate:int=ObjectUtil.dateCompare(fromDateObj,toDateObj);
            // check Form Date not less than To Date
            if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.date.fromlessto')));
            }
            // 
            if (!XenosStringUtils.isBlank(ccyCode) && !XenosStringUtils.isBlank(instrumentId)) {
                results.push(new ValidationResult(true, 
                    "", "instrument", Application.application.xResourceManager.getKeyValue('ncm.error.prompt.enter.ccysecurity')));
            }
            
            return results;     
        } 
        
	}
}