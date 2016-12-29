// ActionScript file


package com.nri.rui.frx.validators
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
	public class NdfRevalExchangeRateQueryValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function NdfRevalExchangeRateQueryValidator()
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
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('frx.value.obj.null'));
                return null;
            }
            
            var dateList:Array = [];
            
        	var baseDateFrom:String =value.baseDateFrom;
        	if(baseDateFrom != "")
        		dateList.push(baseDateFrom);
            var baseDateTo:String =value.baseDateTo;
            if(baseDateTo != "")
            	dateList.push(baseDateTo);
            var entryDateFrom:String =value.entryDateFrom;
            if(entryDateFrom != "")
            	dateList.push(entryDateFrom);
            var entryDateTo:String=value.entryDateTo;
            if(entryDateTo != "")
            	dateList.push(entryDateTo);
            var updateDateFrom:String=value.updateDateFrom;
            if(updateDateFrom != "")
            	dateList.push(updateDateFrom);
            var updateDateTo:String=value.updateDateTo;
            if(updateDateTo != "")
            	dateList.push(updateDateTo);
            var flag:int=0;            
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
            
            var dateObj:Array = [];
            
            for(var iterator:int=0; iterator<dateList.length; iterator++){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
	            
	            if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator]))){
	            dateObj[iterator] = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
	             
	            }else{
	                
	                results.push(new ValidationResult(true, 
	                    "toDate", "illegaltoDate",  Application.application.xResourceManager.getKeyValue('frx.error.illegal.date') + dateList[iterator]));
	                return results;
	            }
            
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
            	var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check Form Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate",  Application.application.xResourceManager.getKeyValue('frx.error.date.compare')));
	            }
            }
        	return results;
        }
	}
}