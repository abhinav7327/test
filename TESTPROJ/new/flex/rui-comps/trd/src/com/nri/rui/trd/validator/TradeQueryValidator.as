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
	public class TradeQueryValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function TradeQueryValidator()
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
            
            var dateList:Array = [];
            
        	var trdDateFrom:String =value.trddateFrom;
        	if(trdDateFrom != "")
        		dateList.push(trdDateFrom);
            var trdDateTo:String =value.trddateTo;
            if(trdDateTo != "")
            	dateList.push(trdDateTo);
            var valueDateFrom:String =value.valuedateFrom;
            if(valueDateFrom != "")
            	dateList.push(valueDateFrom);
            var valueDateTo:String=value.valuedateTo;
            if(valueDateTo != "")
            	dateList.push(valueDateTo);
            var lastEntryDateFrom:String=value.lastEntryDateFrom;
            if(lastEntryDateFrom != "")
            	dateList.push(lastEntryDateFrom);
            var lastEntryDateTo:String=value.lastEntryDateTo;
            if(lastEntryDateTo != "")
            	dateList.push(lastEntryDateTo);
            var EntrydateFrom:String=value.EntrydateFrom;
            if(EntrydateFrom != "")
            	dateList.push(EntrydateFrom);
            var EntrydateTo:String=value.EntrydateTo;
            if(EntrydateTo != "")
            	dateList.push(EntrydateTo);
            /* var deliveryDateFrom:String=value.deliveryDateFrom;
            if(deliveryDateFrom != "")
            	dateList.push(deliveryDateFrom); 
            var deliveryDateTo:String=value.deliveryDateTo;
            if(deliveryDateTo != "")
            	dateList.push(deliveryDateTo);*/
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
	                    "toDate", "illegaltoDate",  Application.application.xResourceManager.getKeyValue('trd.illegal.datelist') + dateList[iterator]));
	                return results;
	            }
            
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
            	var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check Form Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate",  Application.application.xResourceManager.getKeyValue('trd.invalid.fromtodate')));
	            }
            }
        	return results;
        }
	}
}