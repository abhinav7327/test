// ActionScript file


package com.nri.rui.cam.validators
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
	public class CamSecurityValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function CamSecurityValidator()
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
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('cam.label.object.null'));
                return null;
            }
            
            var dateList:Array = [];
            
        	var fromSecDate:String =value.fromSecDate;
        	if(fromSecDate != "")
        		dateList.push(fromSecDate);
            var toSecDate:String =value.toSecDate;
            if(toSecDate != "")
            	dateList.push(toSecDate);
            var fromAppRegiDate:String =value.fromAppRegiDate;
            if(fromAppRegiDate != "")
            	dateList.push(fromAppRegiDate);
            var toAppRegiDate:String=value.toAppRegiDate;
            if(toAppRegiDate != "")
            	dateList.push(toAppRegiDate);
            var fromUpdateDate:String=value.fromUpdateDate;
            if(fromUpdateDate != "")
            	dateList.push(fromUpdateDate);
            var toUpdateDate:String=value.toUpdateDate;
            if(toUpdateDate != "")
            	dateList.push(toUpdateDate);
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
            
            if (XenosStringUtils.isBlank(fromSecDate)||XenosStringUtils.isBlank(toSecDate))
            {
                results.push(new ValidationResult(true, 
                    "", "emptySecurityDateFrom", Application.application.xResourceManager.getKeyValue('cam.label.enter.security.from.to.date')));
                //return results;
            }
            
            for(var iterator:int=0; iterator<dateList.length; iterator++){
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
	            
	            if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator]))){
	            dateObj[iterator] = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
	             
	            }else{
	                
	                results.push(new ValidationResult(true, 
	                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('cam.label.illegal.date.format') + dateList[iterator]));
	                return results;
	            }
            
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
            	var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check Form Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate",Application.application.xResourceManager.getKeyValue('cam.label.from.date.less.to.date')));
	            }
            }
        	return results;
        }
	}
}