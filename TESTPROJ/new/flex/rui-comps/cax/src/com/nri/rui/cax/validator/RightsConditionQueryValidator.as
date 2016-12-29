
  
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
    
    /**
     * Custom Validator for Cax Rights Condition Query Implementation.
     * 
     */    
    public class RightsConditionQueryValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function RightsConditionQueryValidator()
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
            
        	var exDateFrom:String = value.exDateFrom;
        	if(exDateFrom != "")
        		dateList.push(exDateFrom);
            var exDateTo:String = value.exDateTo;
            if(exDateTo != "")
            	dateList.push(exDateTo);
            	
            	
            	
            var recordDateFrom:String = value.recordDateFrom;
            if(recordDateFrom != "")
            	dateList.push(recordDateFrom);
            var recordDateTo:String = value.recordDateTo;
            if(recordDateTo != "")
            	dateList.push(recordDateTo);
            	
            	
        	var paymentDateFrom:String = value.paymentDateFrom;
            if(paymentDateFrom != "")
            	dateList.push(paymentDateFrom);
            var paymentDateTo:String = value.paymentDateTo;
            if(paymentDateTo != "")
            	dateList.push(paymentDateTo);
            	
            	
            var processStartDateFrom:String = value.processStartDateFrom;
            if(processStartDateFrom != "")
            	dateList.push(processStartDateFrom);
            var processStartDateTo:String = value.processStartDateTo;
            if(processStartDateTo != "")
            	dateList.push(processStartDateTo);
            	
            	
            var processEndDateFrom:String = value.processEndDateFrom;
            if(processEndDateFrom != "")
            	dateList.push(processEndDateFrom);
            var processEndDateTo:String = value.processEndDateTo;
            if(processEndDateTo != "")
            	dateList.push(processEndDateTo);
            	
            	
            var dueBillEndDateFrom:String = value.dueBillEndDateFrom;
            if(dueBillEndDateFrom != "")
            	dateList.push(dueBillEndDateFrom);
            var dueBillEndDateTo:String = value.dueBillEndDateTo;
            if(dueBillEndDateTo != "")
            	dateList.push(dueBillEndDateTo);
            	
            	
            var app_regi_DateFrom:String = value.app_regi_DateFrom;
            if(app_regi_DateFrom != "")
            	dateList.push(app_regi_DateFrom);
            var app_regi_DateTo:String = value.app_regi_DateTo;
            if(app_regi_DateTo != "")
            	dateList.push(app_regi_DateTo);
            	
            	
            var app_upd_DateFrom:String = value.app_upd_DateFrom;
            if(app_upd_DateFrom != "")
            	dateList.push(app_upd_DateFrom);
            var app_upd_DateTo:String = value.app_upd_DateTo;
            if(app_upd_DateTo != "")
            	dateList.push(app_upd_DateTo);
            	
            var paymentDateTakeUpFrom:String = value.paymentDateTakeUpFrom;
            if(paymentDateTakeUpFrom != "")
            	dateList.push(paymentDateTakeUpFrom);
            var paymentDateTakeUpTo:String = value.paymentDateTakeUpTo;
            if(paymentDateTakeUpTo != "")
            	dateList.push(paymentDateTakeUpTo);	
            	
           
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
	                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.general')+" " + dateList[iterator]));
	                return results;
	            }
            
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
            	var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check Form Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('cax.fromdate.greaterthan.todate')));
	            }
            }
        	return results;
        }        
    }
}