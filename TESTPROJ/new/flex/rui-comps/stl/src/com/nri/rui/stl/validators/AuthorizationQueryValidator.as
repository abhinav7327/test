// ActionScript file

package com.nri.rui.stl.validators
{
	import com.nri.rui.core.Globals;
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
	public class AuthorizationQueryValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function AuthorizationQueryValidator()
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
            
        	var trdDateFrom:String =value.trddateFrom;
        		dateList.push(trdDateFrom);
            var trdDateTo:String =value.trddateTo;
            	dateList.push(trdDateTo);
            var valueDateFrom:String =value.valuedateFrom;
            	dateList.push(valueDateFrom);
            var valueDateTo:String=value.valuedateTo;
            	dateList.push(valueDateTo);
            var lastEntryDateFrom:String=value.lastEntryDateFrom;
            	dateList.push(lastEntryDateFrom);
            var lastEntryDateTo:String=value.lastEntryDateTo;
            	dateList.push(lastEntryDateTo);
            var EntrydateFrom:String=value.EntrydateFrom;
            	dateList.push(EntrydateFrom);
            var EntrydateTo:String=value.EntrydateTo;
            	dateList.push(EntrydateTo);
            var SettledateFrom:String=value.settleDateFrom;
            	dateList.push(SettledateFrom);
            var SettledateTo:String=value.settleDateTo;
            	dateList.push(SettledateTo);
            var transmissionDate:String=value.transmissionDate;
            	
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
            
            var dateObjFrom:Date;
            
            var dateObjTo:Date;
            
            for(var iterator:int=0; iterator<dateList.length; iterator+=2){
	            
	            if(StringUtil.trim(dateList[iterator]) != Globals.EMPTY_STRING){
	            	formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
		            if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator]))){
		            dateObjFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
		             
		            }else{
		                
		                results.push(new ValidationResult(true, 
		                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('stl.message.error.illegaldateformat') + dateList[iterator]));
		                return results;
		            }
		        }
		        
		        if(StringUtil.trim(dateList[iterator+1]) != Globals.EMPTY_STRING){
	            	formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator+1]));
		            if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator+1]))){
		            dateObjTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator+1]));
		             
		            }else{
		                
		                results.push(new ValidationResult(true, 
		                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('stl.message.error.illegaldateformat') + dateList[iterator+1]));
		                return results;
		            }
		        }
	            if(StringUtil.trim(dateList[iterator]) != Globals.EMPTY_STRING && StringUtil.trim(dateList[iterator+1]) != Globals.EMPTY_STRING){
	            	if (ObjectUtil.dateCompare(dateObjFrom,dateObjTo)==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('stl.message.error.fromdateshouldbelessthantodate')));
	            }
	            }
            
            }
                        
            if(StringUtil.trim(transmissionDate)!=Globals.EMPTY_STRING){
            	if(!DateUtils.isValidDate(StringUtil.trim(transmissionDate))){
            		results.push(new ValidationResult(true,"transmissionDate","IllegaltransmissionDate",Application.application.xResourceManager.getKeyValue('stl.message.error.illegaldateformat')+transmissionDate));
            		return results;
            	}
            }
            
        	return results;
        }
	}
}