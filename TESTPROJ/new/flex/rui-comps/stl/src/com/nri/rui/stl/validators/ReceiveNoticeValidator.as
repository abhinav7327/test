// ActionScript file


package com.nri.rui.stl.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    
    /**
     * Custom Validator for Receive Notice Query Implementation.
     * 
     */   
	public class ReceiveNoticeValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function ReceiveNoticeValidator()
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
                XenosAlert.info("value object is null");
                return null;
            }
            
            var dateList:Array = [];
            
        	var fromDate:String =value.settleDateFrom; 
        	if(fromDate != "")
        		dateList.push(fromDate);       	
            var toDate:String =value.settleDateTo;
            if(toDate != "")
        		dateList.push(toDate);  
        		
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
            
            if (XenosStringUtils.isBlank(fromDate))
            {
                results.push(new ValidationResult(true, 
                    "", "emptySettlementDateFrom", "Please Enter a valid Settlement Date(From)."));
                return results;
            }
            
            for(var i:int=0; i<dateList.length; i++){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[i]));
	            
	            if(DateUtils.isValidDate(StringUtil.trim(dateList[i]))){
	                dateObj[i] = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[i]));	             
	            }else{	                
	                results.push(new ValidationResult(true, 
	                    "toDate", "illegaltoDate", "Illegal Date Format " + dateList[i]));
	                return results;
	            }
            
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
            	var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check Form Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate", "From Date should be less than To Date."));
	            }
            }
        	return results;
        }
	}
}