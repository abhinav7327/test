// ActionScript file


package com.nri.rui.trd.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */   
	public class CommissionQueryValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function CommissionQueryValidator()
        {
            super();
        }
               
        /**
         * 
         * validate movement query form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
            if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('trd.value.obj.null'));
                return null;
            }
            var formatData:String ="";
            var dateformat:CustomDateFormatter = new CustomDateFormatter();
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                 
            // Return if there are errors.
            if (results.length > 0)
                return results;
            
            /*
             * Date Validation
             */
            var trddateFrom:Date = null;
        	if(value.trddateFrom != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.trddateFrom));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.trddateFrom))) {
	                
	                results.push(new ValidationResult(true, 
	                    "tradeDateFrom", "illegalTradeDateFrom", Application.application.xResourceManager.getKeyValue('trd.invalid.tradedate.from')  + value.trddateFrom));
	            }else{
	            	trddateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.trddateFrom));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "tradeDateFrom", "tradeDateFromMissing", Application.application.xResourceManager.getKeyValue('trd.trddatefrom.missing')));
        	}
        	var trddateTo:Date = null;
        	if(value.trddateTo != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.trddateTo));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.trddateTo))) {
	                results.push(new ValidationResult(true, 
	                    "tradeDateTo", "illegalTradeDateTo", Application.application.xResourceManager.getKeyValue('trd.invalid.tradedate.to')  + value.trddateTo));
	            }else{
	            	trddateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.trddateTo));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "tradeDateTo", "tradeDateToMissing", Application.application.xResourceManager.getKeyValue('trd.trddateto.missing')));
        	}
        	var comDate:int = 0;
        	if(trddateTo != null && trddateFrom != null){
        		if(ObjectUtil.dateCompare(trddateFrom,trddateTo) == 1){
	        		results.push(new ValidationResult(true, 
	                    "", "tradeDateFromLessThanTradeDateTo",  Application.application.xResourceManager.getKeyValue('trd.error.datecompare.tradedate.tofrom')));
	        	}
        	}
        	return results;
        }
	}
}