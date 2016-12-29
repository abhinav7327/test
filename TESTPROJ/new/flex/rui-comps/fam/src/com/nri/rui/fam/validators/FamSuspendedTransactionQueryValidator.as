// ActionScript file

  
package com.nri.rui.fam.validators
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
     * Custom Validator for Cam Transaction Query Implementation.
     * 
     */    
    public class FamSuspendedTransactionQueryValidator extends Validator
    {
    	 // Define Array for the return value of doValidation().
        private var results:Array;
        //Last entry time from.
        private var lastEntryDateTimeFromText:String;
        //Last entry time to.
        private var lastEntryDateTimeToText:String;
        //set the hour from Last entry time(from).
        private var numFromHH:Number;
        //set the minute from Last entry time(from).
        private var numFromMM:Number;
        //set the second from Last entry time(from).
        private var numFromSS:Number;
        //set the hour from Last entry time(to).
        private var numToHH:Number;
        //set the minute from Last entry time(to).
        private var numToMM:Number;
        //set the second from Last entry time(to).
        private var numToSS:Number;
		//Constant for illegaltoDate
		private static const ILLEGAL_DATE: String = "illegaltoDate";
		//A property for screen label against which user input is obtained
		private static const LABEL: String = "LABEL";
		//A property for user input obtained through screen
		private static const VALUE: String = "VALUE";
        
      
        // constructor
        public function FamSuspendedTransactionQueryValidator()
        {
            super();
        }
        
		
		// Returns an object with two String properties 1) LABEL, 2) VALUE
		private function getLabelInputObject(labelStr:String, inputStr:String):Object{
		        var obj:Object = new Object();
				obj[LABEL]= labelStr ;
				obj[VALUE]= inputStr;
				return obj;
		}
		
		
		

		/**
		 *
		 * validate cam transaction query form
		 */

		protected override function doValidation(value:Object):Array
		{
			if (value == null)
			{
				XenosAlert.info(Application.application.xResourceManager.getKeyValue('fam.label.object.null'));
				return null;
			}

			var entryDateList:Array=[];
			var lastEntryDateTimeList:Array=[];
			
			var entryDateFrom:String=value.entryDateFrom;
			var entryDateTo:String=value.entryDateTo;
			var isAllFundSelected:Boolean=value.isAllFundSelected;

			if (!XenosStringUtils.isBlank(entryDateFrom))
			{
			    entryDateList.push(getLabelInputObject("Entry Date From", entryDateFrom));
			}
			if (!XenosStringUtils.isBlank(entryDateTo))
			{
				entryDateList.push(getLabelInputObject("Entry Date To", entryDateTo));
			}

			// Clear results Array.
			results=[];

			// Call base class's doValidation().
			results=super.doValidation(value);

			// Return if there are errors.
			if (results.length > 0)
				return results;
			var dateformat:CustomDateFormatter=new CustomDateFormatter();
			//format of the date
			dateformat.formatString="YYYYMMDD";
			var formatData:String=XenosStringUtils.EMPTY_STR;
			var entryDateObj:Array=[];
						
			for (var i:int=0; i < entryDateList.length; i++) {
			    var obj:Object = entryDateList[i];
				var input:String = obj[VALUE];
				var label:String = obj[LABEL];
				
				if (DateUtils.isValidDate(StringUtil.trim(input))) {
					entryDateObj[i]=dateformat.toDate(CustomDateFormatter.customizedInputDateString(input));
				} else {
				    results.push(new ValidationResult(true, "toDate", ILLEGAL_DATE, Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.date', new Array([label],[input]))));
				}
			}
			
			if (results.length > 0)
				return results;
				
			for (var itr4:int=0; itr4 < entryDateObj.length; itr4 += 2) {
				var comDate5:int=ObjectUtil.dateCompare(entryDateObj[itr4], entryDateObj[itr4 + 1]);
				// check Form Date not less than To Date
				if (comDate5 == 1) {
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionquery.from.lastentry.date.lessthan.to.date')));
				}
			}
			return results;
		}
    }
}