
package com.nri.rui.cax.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class RightsDetailQueryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results : Array;
        
		public function RightsDetailQueryValidator()
		{
			super();
		}
		
		/**
         * validate entitlement query form
         */ 
        protected override function doValidation(value : Object) : Array
        {
        	if (value == null) {
                XenosAlert.info("value object is null");
                return null;
            }
            
             var dateList:Array = [];
             var comDate:int = 0;
          	
          	dateList.push(value.recordDateFrom);
          	dateList.push(value.recordDateTo);
          	dateList.push(value.paymentDateFrom);
          	dateList.push(value.paymentDateTo);
          	dateList.push(value.exDateFrom);
          	dateList.push(value.exDateTo);
          	dateList.push(value.processStartDateFrom);
          	dateList.push(value.processStartDateTo);
          	dateList.push(value.processEndDateFrom);
          	dateList.push(value.processEndDateTo);
          	dateList.push(value.entryDateFrom);
          	dateList.push(value.entryDateTo);
          	dateList.push(value.lastEntryDateFrom);
          	dateList.push(value.lastEntryDateTo);
          	dateList.push(value.availableDateFrom);
          	dateList.push(value.availableDateTo);
          
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
            
            var dateObjFrom:Date;
            
            var dateObjTo:Date;  
            for(var iterator:int=0; iterator<dateList.length; iterator+=2){
	            
	            if(StringUtil.trim(dateList[iterator]) != ""){
	            	formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
		            if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator]))){
		            dateObjFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
		             
		            }else{
		                
		                results.push(new ValidationResult(true, 
		                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.general')+" " + dateList[iterator]));
		                return results;
		            }
		        }
		        
		        if(StringUtil.trim(dateList[iterator+1]) != ""){
	            	formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator+1]));
		            if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator+1]))){
		            dateObjTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator+1]));
		             
		            }else{
		                
		                results.push(new ValidationResult(true, 
		                    "toDate", "illegaltoDate",Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.general')+" " + dateList[iterator+1]));
		                return results;
		            }
		        }
	            if(StringUtil.trim(dateList[iterator]) != "" && StringUtil.trim(dateList[iterator+1]) != ""){
	            	if (ObjectUtil.dateCompare(dateObjFrom,dateObjTo)==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('cax.fromdate.greaterthan.todate')));
	            }
	            }
            
            }  
          return results;   
        }  

	}
}