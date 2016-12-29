// ActionScript file


package com.nri.rui.bkg.validators
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
	public class BkgTradeQueryValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function BkgTradeQueryValidator()
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
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('bkg.value.obj.null'));
                return null;
            }
            
            var dateList:Array = [];
            
        	var tradeDateFrom:String =value.tradeDateFrom;
        	if(tradeDateFrom != "")
        		dateList.push(tradeDateFrom);
            var tradeDateTo:String =value.tradeDateTo;
            if(tradeDateTo != "")
            	dateList.push(tradeDateTo);
            var startDateFrom:String =value.startDateFrom;
            if(startDateFrom != "")
            	dateList.push(startDateFrom);
            var startDateTo:String=value.startDateTo;
            if(startDateTo != "")
            	dateList.push(startDateTo);
            var maturityDateFrom:String=value.maturityDateFrom;
            if(maturityDateFrom != "")
            	dateList.push(maturityDateFrom);
            var maturityDateTo:String=value.maturityDateTo;
            if(maturityDateTo != "")
            	dateList.push(maturityDateTo);
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
	                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('bkg.error.illegal.date') + dateList[iterator]));
	                return results;
	            }
            
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
            	var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check Form Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('bkg.error.date.compare')));
	            }
            }
        	return results;
        }
	}
}