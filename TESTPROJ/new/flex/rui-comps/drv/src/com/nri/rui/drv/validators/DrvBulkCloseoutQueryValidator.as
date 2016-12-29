
 
package com.nri.rui.drv.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    /**
     * Custom Validator for Derivative Trade Query
     */ 
    public class DrvBulkCloseoutQueryValidator extends Validator {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function DrvBulkCloseoutQueryValidator()
        {
            super();
        }
        
        /**
         * 
         * validate Drv Trade query form
         */       
        protected override function doValidation(value:Object):Array{
             if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('drv.alert.value.object.null'));
                return null;
            }
            
            var dateList:Array = [];
            
        	var trdDateFrom:String =value.tradeDateFrom;
        	if(trdDateFrom != "")
        		dateList.push(trdDateFrom);
            var trdDateTo:String =value.tradeDateTo;
            if(trdDateTo != "")
            	dateList.push(trdDateTo);
            var valueDateFrom:String =value.valueDateFrom;
            if(valueDateFrom != "")
            	dateList.push(valueDateFrom);
            var valueDateTo:String=value.valueDateTo;
            if(valueDateTo != "")
            	dateList.push(valueDateTo);
            
            var flag:int=0;
            
            // Clear results Array.
            results = [];

			var formatData:String = XenosStringUtils.EMPTY_STR;
			var dateformat:CustomDateFormatter = new CustomDateFormatter();
            // Call base class's doValidation().
            results = super.doValidation(value);
                 
            // Return if there are errors.
            if (results.length > 0)
                return results;
            
            var tdFrom:Date = null;
            var tdTo:Date = null;
            var vdFrom:Date = null;
            var vdTo:Date = null;
            var comDate:int = 0;
        	if(value.tradeDateFrom != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDateFrom));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.tradeDateFrom))) {
	                
	                results.push(new ValidationResult(true, 
	                    "tradeDateFrom", "illegalTradeDateFrom", Application.application.xResourceManager.getKeyValue('drv.validator.invalid.tradedatefrm')  + value.tradeDateFrom));
	            }else{
	            	tdFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.tradeDateFrom));
	            }
        	}
        	
        	if(value.tradeDateTo != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDateTo));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.tradeDateTo))) {
	                results.push(new ValidationResult(true, 
	                    "tradeDateTo", "illegalTradeDateTo", Application.application.xResourceManager.getKeyValue('drv.validator.invalid.tradedateto')  + value.tradeDateTo));
	            }else{
	            	tdTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.tradeDateTo));
	            }
        	}
        	
        	if(tdTo != null && tdFrom != null){
        		if(ObjectUtil.dateCompare(tdFrom,tdTo) == 1){
	        		results.push(new ValidationResult(true, 
	                    "", "tradeDateFromLessThanTradeDateTo",  Application.application.xResourceManager.getKeyValue('drv.validator.tradedatefrm.lesstradedateto')));
	        	}
        	}
        	
        	if(value.valueDateFrom != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDateFrom));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDateFrom))) {
	                
	                results.push(new ValidationResult(true, 
	                    "valueDateFrom", "illegalValueDateFrom", Application.application.xResourceManager.getKeyValue('drv.validator.invalid.valuedatefrm')  + value.valueDateFrom));
	            }else{
	            	vdFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.valueDateFrom));
	            }
        	}
        	
        	if(value.valueDateTo != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDateTo));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDateTo))) {
	                results.push(new ValidationResult(true, 
	                    "valueDateTo", "illegalValueDateTo", Application.application.xResourceManager.getKeyValue('drv.validator.invalid.valuedateto')  + value.valueDateTo));
	            }else{
	            	vdTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.valueDateTo));
	            }
        	}
        	
        	if(vdTo != null && vdFrom != null){
        		if(ObjectUtil.dateCompare(vdFrom,vdTo) == 1){
	        		results.push(new ValidationResult(true, 
	                    "", "valueDateFromLessThanValueDateTo",  Application.application.xResourceManager.getKeyValue('drv.validator.valuedatefrm.lessvaluedateto')));
	        	}
        	}
        	return results;
        }
        
    }
}