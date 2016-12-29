// ActionScript file


package com.nri.rui.oms.validator
{
	import mx.core.Application;
	import mx.validators.Validator;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	
	public class OrderMatchingQueryValidator extends Validator {
	
		// Define Array for the return value of doValidation().
        private var results:Array;
        
		public function OrderMatchingQueryValidator()
		{
			super();
		}
		protected override function doValidation(value:Object):Array {
        	
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
        	
        	var dateList:Array = [];
        	var dateformat:CustomDateFormatter =new CustomDateFormatter();
	        //format of the date
	        dateformat.formatString="YYYYMMDD";
	        var formatData:String ="";
	        
        	        	if(value.tradeDateFrom != ""){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDateFrom));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.tradeDateFrom))) {
	                results.push(new ValidationResult(true, 
	                    "tradeDateFrom", "illegaltradeDateFrom", Application.application.xResourceManager.getKeyValue('oms.order.matching.validation.tdfrom') + value.tradeDateFrom));
	            }
        		
        	}
        	
        	if(value.tradeDateTo != ""){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDateTo));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.tradeDateTo))) {
	                results.push(new ValidationResult(true, 
	                    "tradeDateTo", "illegaltradeDateTo", Application.application.xResourceManager.getKeyValue('oms.order.matching.validation.tdto') + value.tradeDateTo));
	            }
        		
        	}
        	
        	if(value.valueDateFrom != ""){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDateFrom));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDateFrom))) {
	                results.push(new ValidationResult(true, 
	                    "valueDateFrom", "illegalvalueDateFrom", Application.application.xResourceManager.getKeyValue('oms.order.matching.validation.vdfrom') + value.valueDateFrom));
	            }
        		
        	}
        	
        	if(value.valueDateTo != ""){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDateTo));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDateTo))) {
	                results.push(new ValidationResult(true, 
	                    "valueDateTo", "illegalvalueDateTo", Application.application.xResourceManager.getKeyValue('oms.order.matching.validation.vdto') + value.valueDateTo));
	            }
        		
        	}
        	
        	if(value.entrydateFrom != ""){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.entrydateFrom));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.entrydateFrom))) {
	                results.push(new ValidationResult(true, 
	                    "entrydateFrom", "illegalentrydateFrom", Application.application.xResourceManager.getKeyValue('oms.order.matching.validation.edfrom') + value.entrydateFrom));
	            }
        		
        	}
        	
        	if(value.entrydateTo != ""){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.entrydateTo));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.entrydateTo))) {
	                results.push(new ValidationResult(true, 
	                    "entrydateTo", "illegalentrydateTo", Application.application.xResourceManager.getKeyValue('oms.order.matching.validation.edto') + value.entrydateTo));
	            }
        		
        	}
        	
        	if(value.lastentrydateFrom != ""){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.lastentrydateFrom));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.lastentrydateFrom))) {
	                results.push(new ValidationResult(true, 
	                    "lastentrydateFrom", "illegallastentrydateFrom", Application.application.xResourceManager.getKeyValue('oms.order.matching.validation.ledfrom') + value.lastentrydateFrom));
	            }
        		
        	}
        	
        	if(value.lastentrydateTo != ""){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.lastentrydateTo));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.lastentrydateTo))) {
	                results.push(new ValidationResult(true, 
	                    "lastentrydateTo", "illegallastentrydateTo", Application.application.xResourceManager.getKeyValue('oms.order.matching.validation.ledto') + value.lastentrydateTo));
	            }
        		
        	}
                    	
        	
        	return results;
        }

	}
}	