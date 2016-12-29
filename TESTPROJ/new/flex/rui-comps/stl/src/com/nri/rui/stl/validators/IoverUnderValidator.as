// ActionScript file


package com.nri.rui.stl.validators
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
     * Custom Validator for Receive Notice Query Implementation.
     * 
     */   
	public class IoverUnderValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function IoverUnderValidator()
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
            results = [];
            var fundCode:String =value.fundCode; 
            if (XenosStringUtils.isBlank(fundCode)) {
	                    results.push(new ValidationResult(true, 
	                        "", "fundCode", "Please Enter a valid Fund Code."));
	                    return results;
            }


            var subEventType:String =value.subEventType; 
            if (!(XenosStringUtils.equals("CASH_DIVIDEND",subEventType) || XenosStringUtils.equals("COUPON_PAYMENT",subEventType) || XenosStringUtils.equals("SPECIAL_CASH_DEVIDEND",subEventType) || XenosStringUtils.equals("",subEventType))) {
	                    results.push(new ValidationResult(true, 
	                        "", "fundCode", "Please Select only these Event Type: Cash Dividend, Coupon Payment, Special Cash Dividend."));
	                    return results;
            }

            
        	var fromDate:String =value.settleDateFrom; 
        	if(fromDate != "")
        		dateList.push(fromDate);       	
            var toDate:String =value.settleDateTo;
            if(toDate != "")
        		dateList.push(toDate);
        		
        	
        	if(value.tradeDateFrom != "")
        		dateList.push(value.tradeDateFrom);       	
            
            if(value.tradeDateTo != "")
        		dateList.push(value.tradeDateTo);  
        		
            var flag:int=0;
            
            // Clear results Array.
            

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
            
//            if (XenosStringUtils.isBlank(fromDate))
//            {
//                results.push(new ValidationResult(true, 
//                    "", "emptySettlementDateFrom", "Please Enter a valid Settlement Date(From)."));
//                return results;
//            }
            
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
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
            	var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check Form Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('stl.message.error.fromdateshouldbelessthantodate')));
	            }
            }
        	return results;
        }
	}
}