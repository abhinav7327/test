
  
package com.nri.rui.rec.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.NumberUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.utils.ObjectUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
	import mx.utils.StringUtil;
    
    /**
     * Custom Validator for Cam Movement Query Implementation.
     * 
     */    
    public class CashremarksValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function CashremarksValidator()
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
            
        	var fromDate:String =value.fromDate;
        	if(fromDate != "")
        		dateList.push(fromDate);
            var toDate:String =value.toDate;
            if(toDate != "")
            	dateList.push(toDate);
            var creationDateFrom:String =value.creationDateFrom;
            if(creationDateFrom != "")
            	dateList.push(creationDateFrom);
            var creationDateTo:String=value.creationDateTo;
            if(creationDateTo != "")
            	dateList.push(creationDateTo);
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
	                    "toDate", "illegaltoDate", "Illegal date format " + dateList[iterator]));
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