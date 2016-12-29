// ActionScript file


package com.nri.rui.stl.validators
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
     * Custom Validator for Receive Notice Query Implementation.
     * 
     */   
	public class StlAmendQueryValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function StlAmendQueryValidator()
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
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.message.error.objectnull'));
                return null;
            }
            
            var dateList:Array = [];
            var dateFrom:Date;
            var dateTo:Date;
            
        	var trdDateFrom:String =value.trdDateFrom; 
        	if(trdDateFrom != "")
        		dateList.push(trdDateFrom);       	
            var trdDateTo:String =value.trdDateTo;
            if(trdDateTo != "")
        		dateList.push(trdDateTo);
        	var valueDateFrom:String =value.valueDateFrom;
            if(valueDateFrom != "")
        		dateList.push(valueDateFrom);
        	var valueDateTo:String =value.valueDateTo;
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
            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            //format of the date
            dateformat.formatString="YYYYMMDD";
            var formatData:String ="";
            
            var dateObj:Array = [];
            
            for(var i:int=0; i<dateList.length; i++){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[i]));
	            
	            if(DateUtils.isValidDate(StringUtil.trim(dateList[i]))){
	                dateObj[i] = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[i]));	             
	            }else{	                
	                results.push(new ValidationResult(true, 
	                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('stl.message.error.illegaldateformat') + dateList[i]));
	                return results;
	            }
            
            }
            
            var comDate:int;
            
            dateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(trdDateFrom));	
            dateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(trdDateTo));	
            comDate = ObjectUtil.dateCompare(dateFrom,dateTo);
            // check Form Date not less than To Date
            if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('stl.message.error.fromtrddateshouldbelessthantrdtodate')));
            }
            
            dateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valueDateFrom));	
            dateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valueDateTo));	
            comDate = ObjectUtil.dateCompare(dateFrom,dateTo);
            // check Form Date not less than To Date
            if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('stl.message.error.fromvddateshouldbelessthanvdtodate')));
            }            
            
        	return results;
        }
	}
}