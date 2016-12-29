


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
    public class FamTransactionAmendQryValidator extends Validator
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
        public function FamTransactionAmendQryValidator() {
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
		protected override function doValidation(value:Object):Array {
			if (value == null)
			{
				XenosAlert.info(Application.application.xResourceManager.getKeyValue('fam.label.object.null'));
				return null;
			}
			var bookDateList:Array=[];
			var tradeDateList:Array=[];
			var valueDateList:Array=[];
			var originalBookDateList:Array=[];
			var tradeDateFrom:String=value.tradeDateFrom;
			var tradeDateTo:String=value.tradeDateTo;
			var valueDateFrom:String=value.valueDateFrom;
			var valueDateTo:String=value.valueDateTo;
			var bookDateFrom:String=value.bookDateFrom;
			var bookDateTo:String=value.bookDateTo;
			var originalBookDateFrom:String=value.originalBookDateFrom;
			var originalBookDateTo:String=value.originalBookDateTo;
			var securityCode:String=value.securityCode;
			var transactionType:String=value.transactionType;
			var isAllFundSelected:Boolean=value.isAllFundSelected;

			if (!XenosStringUtils.isBlank(bookDateFrom))
			{
				bookDateList.push(getLabelInputObject("Book Date From", bookDateFrom));;
			}
			if (!XenosStringUtils.isBlank(bookDateTo))
			{
				bookDateList.push(getLabelInputObject("Book Date To", bookDateTo));
			}
			if (!XenosStringUtils.isBlank(tradeDateFrom))
			{
				tradeDateList.push(getLabelInputObject("Trade Date From", tradeDateFrom));
			}
			if (!XenosStringUtils.isBlank(tradeDateTo))
			{
				tradeDateList.push(getLabelInputObject("Trade Date To", tradeDateTo));
			}
			if (!XenosStringUtils.isBlank(originalBookDateFrom))
			{
			    originalBookDateList.push(getLabelInputObject("Original Book Date From", originalBookDateFrom));
			}
			if (!XenosStringUtils.isBlank(originalBookDateTo))
			{
				originalBookDateList.push(getLabelInputObject("Original Book Date To", originalBookDateTo));
			}
			if (!XenosStringUtils.isBlank(valueDateFrom))
			{
				valueDateList.push(getLabelInputObject("Value Date From", valueDateFrom));
			}
			if (!XenosStringUtils.isBlank(valueDateTo))
			{
				valueDateList.push(getLabelInputObject("Value Date To", valueDateTo));
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
			var tradeDateObj:Array=[];
			var bookDateObj:Array=[];
			var valueDateObj:Array=[];
			var originalBookDateObj:Array=[];

			if (isAllFundSelected)
			{
				if ((XenosStringUtils.isBlank(tradeDateFrom)) && (XenosStringUtils.isBlank(valueDateFrom)) && (XenosStringUtils.isBlank(bookDateFrom)) && (XenosStringUtils.isBlank(originalBookDateFrom))
				     && (XenosStringUtils.isBlank(securityCode)) && (XenosStringUtils.isBlank(transactionType)))
				{

					results.push(new ValidationResult(true, "fundCode", "nofund", Application.application.xResourceManager.getKeyValue('fam.transactionqueryamend.label.all.fund.code.selected')));
					return results;
				}
			}

			
			for (var i:int=0; i < tradeDateList.length; i++)
			{
				var obj:Object = tradeDateList[i];
				var input:String = obj[VALUE];
				var label:String = obj[LABEL];
			
				if (DateUtils.isValidDate(StringUtil.trim(input)))
				{
					tradeDateObj[i]=dateformat.toDate(CustomDateFormatter.customizedInputDateString(input));

				}
				else
				{
					results.push(new ValidationResult(true, "toDate", ILLEGAL_DATE, Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.date', new Array([label],[input]))));
				}

			}

			for (var itr1:int=0; itr1 < tradeDateObj.length; itr1 += 2)
			{
				var comDate2:int=ObjectUtil.dateCompare(tradeDateObj[itr1], tradeDateObj[itr1 + 1]);
				// check Form Date not less than To Date
				if (comDate2 == 1)
				{
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionamend.from.tradedatelessthan.to.date')));
				}
			}


			for (i=0; i < valueDateList.length; i++)
			{
			    obj = valueDateList[i];
				input = obj[VALUE];
				label = obj[LABEL];				

				if (DateUtils.isValidDate(StringUtil.trim(input)))
				{
					valueDateObj[i]=dateformat.toDate(CustomDateFormatter.customizedInputDateString(input));

				}
				else
				{
				   
					results.push(new ValidationResult(true, "toDate", ILLEGAL_DATE, Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.date', new Array([label],[input]))));
					
				}

			}

			for (var itr2:int=0; itr2 < valueDateObj.length; itr2 += 2)
			{
				var comDate3:int=ObjectUtil.dateCompare(valueDateObj[itr2], valueDateObj[itr2 + 1]);
				// check Form Date not less than To Date
				if (comDate3 == 1)
				{
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionamend.from.valuedatelessthan.to.date')));
				}
			}

			for (i=0; i < originalBookDateList.length; i++)
			{
			    obj = originalBookDateList[i];
				input = obj[VALUE];
				label = obj[LABEL];
				
				if (DateUtils.isValidDate(StringUtil.trim(input)))
				{
					originalBookDateObj[i]=dateformat.toDate(CustomDateFormatter.customizedInputDateString(input));

				}
				else
				{
					results.push(new ValidationResult(true, "toDate", ILLEGAL_DATE, Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.date', new Array([label],[input]))));
					
				}

			}

			for (var itr3:int=0; itr3 < originalBookDateObj.length; itr3 += 2)
			{
				var comDate4:int=ObjectUtil.dateCompare(originalBookDateObj[itr3], originalBookDateObj[itr3 + 1]);
				// check Form Date not less than To Date
				if (comDate4 == 1)
				{
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionqueryamend.from.originalbookdatelessthan.to.date')));
				}
			}
			
			for (i=0; i < bookDateList.length; i++)
			{
			    obj = bookDateList[i];
				input = obj[VALUE];
				label = obj[LABEL];				

				if (DateUtils.isValidDate(StringUtil.trim(input)))
				{
					bookDateObj[i]=dateformat.toDate(CustomDateFormatter.customizedInputDateString(input));

				}
				else
				{
				    results.push(new ValidationResult(true, "toDate", ILLEGAL_DATE, Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.date', new Array([label],[input]))));
				}
			}
			
			for (var itr6:int=0; itr6 < bookDateObj.length; itr6 += 2)
			{
				var comDate1:int=ObjectUtil.dateCompare(bookDateObj[itr6], bookDateObj[itr6 + 1]);
				// check Form Date not less than To Date
				if (comDate1 == 1)
				{
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionqamend.from.bookdatelessthan.to.date')));
				}
			}
			
			return results;
		}

    }
}