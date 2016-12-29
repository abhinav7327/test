
package com.nri.rui.nam.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;

	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class NamFeedQueryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;

		public function NamFeedQueryValidator()
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
            var creationDate:String=value.creationDate;
            if(creationDate != "")
            	dateList.push(creationDate);

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
        	return results;
        }
	}
}