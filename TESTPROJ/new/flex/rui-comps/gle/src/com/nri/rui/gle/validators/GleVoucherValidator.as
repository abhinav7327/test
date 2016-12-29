// ActionScript file


package com.nri.rui.gle.validators
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
     * Custom Validator for Trade Query Implementation.
     * 
     */   
	public class GleVoucherValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function GleVoucherValidator()
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
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('gle.error.validation.object.null'));
                return null;
            }
            
            var dateList:Array = [];
            var transactionDate:String=value.transactionDate;
            var bookDate:String=value.bookDate;            
            
        	var entrydateFrom:String =value.entrydateFrom;
        	if(entrydateFrom != "")
        		dateList.push(entrydateFrom);
            var entrydateTo:String =value.entrydateTo;
            if(entrydateTo != "")
            	dateList.push(entrydateTo);
            var updatedateFrom:String =value.updatedateFrom;
            if(updatedateFrom != "")
            	dateList.push(updatedateFrom);
            var updateDateTo:String=value.updateDateTo;
            if(updateDateTo != "")
            	dateList.push(updateDateTo);
            
            var flag:int=0;
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
            
            
            
            // Transaction Date validation
            if(!XenosStringUtils.isBlank(transactionDate)){
                if(!DateUtils.isValidDate(transactionDate)){                
                    results.push(new ValidationResult(true, 
                            "transactionDate", "invalidTransactionDate", Application.application.xResourceManager.getKeyValue('gle.label.invalid.transaction.date'))); 
                }
            }
            
            // Book Date validation
            if(!XenosStringUtils.isBlank(bookDate)){
                if(!DateUtils.isValidDate(bookDate)){                
                    results.push(new ValidationResult(true, 
                            "bookDate", "invalidBookDate", Application.application.xResourceManager.getKeyValue('gle.label.invalid.book.date'))); 
                }
            }
                 
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
	                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('gle.lable.illegal.date.format') + dateList[iterator]));
	                return results;
	            }
            
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
            	var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check Form Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate",  Application.application.xResourceManager.getKeyValue('gle.lable.from.datelessthan.to.date')));
	            }
            }
        	return results;
        }
	}
}