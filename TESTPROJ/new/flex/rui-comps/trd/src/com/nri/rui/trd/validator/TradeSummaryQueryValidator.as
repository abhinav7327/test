// ActionScript file


package com.nri.rui.trd.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.startup.XenosApplication;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
   //public var app:XenosApplication = XenosApplication(Application.application);
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */   
	public class TradeSummaryQueryValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function TradeSummaryQueryValidator()
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
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('trd.summaryquery.alert.valueobjnull'));
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
            
            var flag:int=0;
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
               
            // Return if there are errors.
            if (results.length > 0)
                return results;
            
            var count:int = 0;
            if(!XenosStringUtils.isBlank(StringUtil.trim(value.brokerAccountNo))){
            	count++;
            }
            if(!XenosStringUtils.isBlank(StringUtil.trim(value.fundAccountNo))){
            	count++;
            }
            if(!XenosStringUtils.isBlank(StringUtil.trim(value.securityCode))){
            	count++;
            }
            if(!XenosStringUtils.isBlank(StringUtil.trim(value.basketId))){
            	count++;
            }
            if(!XenosStringUtils.isBlank(StringUtil.trim(value.trddateFrom)) || 
            	!XenosStringUtils.isBlank(StringUtil.trim(value.trddateTo))){
            	count++;
            }
            if(!XenosStringUtils.isBlank(StringUtil.trim(value.valuedateFrom)) || 
            	!XenosStringUtils.isBlank(StringUtil.trim(value.valuedateTo))){
            	count++;
            }
            
            if(count < 2){
            	results.push(new ValidationResult(true, 
	                     "", "atLeastTwoFieldsRequired", Application.application.xResourceManager.getKeyValue('trd.summaryquery.alert.twocriteria')));
	            
	            return results;
            }
            
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
	                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('trd.summaryquery.alert.illegaldate') + dateList[iterator]));
	                return results;
	            }
            
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
            	var comDate:int = ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check Form Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('trd.summaryquery.alert.frdatelessthantodate')));
	            }
            }
        	return results;
        }
	}
}