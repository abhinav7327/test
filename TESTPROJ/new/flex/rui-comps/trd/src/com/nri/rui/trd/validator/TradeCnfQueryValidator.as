// ActionScript file


package com.nri.rui.trd.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */   
	public class TradeCnfQueryValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function TradeCnfQueryValidator()
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
            
            var dateList:Array = new Array();
            
        	var trdDateFrom:String =value.trddateFrom;
        	if(trdDateFrom != "")
        		dateList.push(["TradeDateFrom",trdDateFrom]);
            var trdDateTo:String =value.trddateTo;
            if(trdDateTo != "")
            	dateList.push(["TradeDateTo",trdDateTo]);
            var valueDateFrom:String =value.valuedateFrom;
            if(valueDateFrom != "")
            	dateList.push(["ValueDateFrom",valueDateFrom]);
            var valueDateTo:String=value.valuedateTo;
            if(valueDateTo != "")
            	dateList.push(["ValueDateTo",valueDateTo]);
            var EntrydateFrom:String=value.EntrydateFrom; 
            if(EntrydateFrom != "")
            	dateList.push(["ReceiveDateFrom",EntrydateFrom]);
            var EntrydateTo:String=value.EntrydateTo;
            if(EntrydateTo != "")
            	dateList.push(["ReceiveDateTo",EntrydateTo]);
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
            //var formatData:String ="";
            
            var dateObj:Array = new Array();
            var keyObj:Array = new Array();
            
             for(var iterator:int=0; iterator<dateList.length; iterator++){
	            //formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator][1]));
	            
	            if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator][1]))){
	            	//Alert.show("aaa "+dateList[iterator][0]);
	            	keyObj[iterator] = dateList[iterator][0];
	            	dateObj[iterator] = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator][1]));
	             
	            }else{
	            	if(dateList[iterator][1]==trdDateFrom && dateList[iterator][0]=="TradeDateFrom"){
	            		results.push(new ValidationResult(true, 
	                    "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('trd.invalid.tradedate.from')));
	            	}else if(dateList[iterator][1]==trdDateTo && dateList[iterator][0]=="TradeDateTo"){
	            		results.push(new ValidationResult(true, 
	                    "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('trd.invalid.tradedate.to')));
	            	}else if(dateList[iterator][1]==valueDateFrom && dateList[iterator][0]=="ValueDateFrom"){
	            		results.push(new ValidationResult(true, 
	                    "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('trd.invalid.valuedate.from')));
	            	}else if(dateList[iterator][1]==valueDateTo && dateList[iterator][0]=="ValueDateTo"){
	            		results.push(new ValidationResult(true, 
	                    "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('trd.invalid.valuedate.to')));
	            	}else if(dateList[iterator][1]==EntrydateFrom && dateList[iterator][0]=="ReceiveDateFrom"){
	            		results.push(new ValidationResult(true, 
	                    "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('trd.invalid.rcvdate.from')));
	            	}else if(dateList[iterator][1]==EntrydateTo && dateList[iterator][0]=="ReceiveDateTo"){
	            		results.push(new ValidationResult(true, 
	                    "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('trd.invalid.rcvdate.to')));
	            	}
	            } 
            }  
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
            	var comDate:int = 0;
            	if((keyObj[itr]=="TradeDateFrom") || (keyObj[itr+1]=="TradeDateTo")){
            		comDate =ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            	// check Form Date not less than To Date
		            if (comDate==1) {
		                results.push(new ValidationResult(true, 
		                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('trd.error.datecompare.tradedate.tofrom')));
		            }
            	}else if((keyObj[itr]=="ValueDateFrom") || (keyObj[itr+1]=="ValueDateTo")){
            		comDate =ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            	// check Form Date not less than To Date
		            if (comDate==1) {
		                results.push(new ValidationResult(true, 
		                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('trd.error.datecompare.valuedate.tofrom')));
		            }
            	}else if((keyObj[itr]=="ReceiveDateFrom") || (keyObj[itr+1]=="ReceiveDateTo")){
            		comDate =ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            	// check Form Date not less than To Date
		            if (comDate==1) {
		                results.push(new ValidationResult(true, 
		                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('trd.error.datecompare.rcvdate.tofrom')));
		            }
            	}
            	
            }
        	return results;
        }
	}
}