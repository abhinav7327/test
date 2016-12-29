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
    public class FamTransactionQueryValidator extends Validator
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
        public function FamTransactionQueryValidator()
        {
            super();
        }
         /**
		 *
		 * validate Last Entry  Time From 
		 */
		private function validateFromTime(lastEntryDateTimeFromText:String):void
		{
			if(XenosStringUtils.isBlank(lastEntryDateTimeFromText))
			{
				lastEntryDateTimeFromText ="00:00:00";
			}
			var timeFromVal:String=StringUtil.trim(lastEntryDateTimeFromText);
			var m:Number=0;
			var s:Number=0;
			if (timeFromVal.length == 8)
			{
				m=3;
				s=6;
			}
			else if (timeFromVal.length == 6)
			{
				m=2;
				s=4;
			}
			else if (timeFromVal.length == 5)
			{
				m=3;
			}
			else if (timeFromVal.length == 4)
			{
				m=2;
			}
			var strHH:String=timeFromVal.charAt(0) + timeFromVal.charAt(1);
			numFromHH=parseInt(strHH);
			var strMM:String=timeFromVal.charAt(m) + timeFromVal.charAt(m + 1);
			numFromMM=parseInt(strMM);

			var strSS:String='00';
			if ((timeFromVal.length == 8) || (timeFromVal.length == 6))
			{
				strSS=timeFromVal.charAt(s) + timeFromVal.charAt(s + 1);
				numFromSS=parseInt(strSS);
			}

		}
         /**
		 *
		 * validate Last Entry  Time To 
		 */
		private function validateToTime(lastEntryDateTimeToText:String):void
		{
			if(XenosStringUtils.isBlank(lastEntryDateTimeToText))
			{
				lastEntryDateTimeToText ="00:00:00";
			}
			var timeToVal:String=StringUtil.trim(lastEntryDateTimeToText);
			var m:Number=0;
			var s:Number=0;
			if (timeToVal.length == 8)
			{
				m=3;
				s=6;
			}
			else if (timeToVal.length == 6)
			{
				m=2;
				s=4;
			}
			else if (timeToVal.length == 5)
			{
				m=3;
			}
			else if (timeToVal.length == 4)
			{
				m=2;
			}
			var strHH:String=timeToVal.charAt(0) + timeToVal.charAt(1);
			numToHH=parseInt(strHH);
			var strMM:String=timeToVal.charAt(m) + timeToVal.charAt(m + 1);
			numToMM=parseInt(strMM);

			var strSS:String='00';
			if ((timeToVal.length == 8) || (timeToVal.length == 6))
			{
				strSS=timeToVal.charAt(s) + timeToVal.charAt(s + 1);
				numToSS=parseInt(strSS);
			}
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

			var bookDateList:Array=[];
			var tradeDateList:Array=[];
			var valueDateList:Array=[];
			var settlementDateList:Array=[];
			var lastEntryDateList:Array=[];
			var lastEntryDateTimeList:Array=[];
			var tradeDateFrom:String=value.tradeDateFrom;
			var tradeDateTo:String=value.tradeDateTo;
			var valueDateFrom:String=value.valueDateFrom;
			var valueDateTo:String=value.valueDateTo;
			var settlementDateFrom:String=value.settlementDateFrom;
			var settlementDateTo:String=value.settlementDateTo;
			var bookDateFrom:String=value.bookDateFrom;
			var bookDateTo:String=value.bookDateTo;
			var lastEntryDateFrom:String=value.lastEntryDateFrom;
			var lastEntryDateTo:String=value.lastEntryDateTo;
			var lastEntryDateTimeFrom:String=value.lastEntryDateTimeFrom;
			var lastEntryDateTimeTo:String=value.lastEntryDateTimeTo;
			var lastEntryDateTimeFromText=value.lastEntryDateTimeFromText;
			var lastEntryDateTimeToText=value.lastEntryDateTimeToText;
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
			if (!XenosStringUtils.isBlank(settlementDateFrom))
			{
			    settlementDateList.push(getLabelInputObject("Settlement Date From", settlementDateFrom));
			}
			if (!XenosStringUtils.isBlank(settlementDateTo))
			{
				settlementDateList.push(getLabelInputObject("Settlement Date To", settlementDateTo));
			}
			if (!XenosStringUtils.isBlank(valueDateFrom))
			{
				valueDateList.push(getLabelInputObject("Value Date From", valueDateFrom));
			}
			if (!XenosStringUtils.isBlank(valueDateTo))
			{
				valueDateList.push(getLabelInputObject("Value Date To", valueDateTo));
			}
			if (!XenosStringUtils.isBlank(lastEntryDateFrom))
			{
			    lastEntryDateList.push(getLabelInputObject("Last Entry Date From", lastEntryDateFrom));
			}
			if (!XenosStringUtils.isBlank(lastEntryDateTo))
			{
				lastEntryDateList.push(getLabelInputObject("Last Entry Date To", lastEntryDateTo));
			}
			if (!XenosStringUtils.isBlank(lastEntryDateTimeFrom))
			{
				lastEntryDateTimeList.push(getLabelInputObject("Last Entry Date (Time) From", lastEntryDateTimeFrom));
			}
			if (!XenosStringUtils.isBlank(lastEntryDateTimeTo))
			{
			    lastEntryDateTimeList.push(getLabelInputObject("Last Entry Date (Time) To", lastEntryDateTimeTo));
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
			var settlementDateObj:Array=[];
			var lastEntryDateObj:Array=[];
			var lastEntryDateTimeObj:Array=[];
			validateFromTime(lastEntryDateTimeFromText);
			validateToTime(lastEntryDateTimeToText);

			if (isAllFundSelected)
			{
				if ((XenosStringUtils.isBlank(tradeDateFrom)) && (XenosStringUtils.isBlank(valueDateFrom)) && (XenosStringUtils.isBlank(settlementDateFrom))
				     && (XenosStringUtils.isBlank(lastEntryDateFrom)) && (XenosStringUtils.isBlank(securityCode)) && (XenosStringUtils.isBlank(transactionType)) && (XenosStringUtils.isBlank(lastEntryDateTimeFrom)))
				{

					results.push(new ValidationResult(true, "fundCode", "nofund", Application.application.xResourceManager.getKeyValue('fam.transactionquery.label.all.fund.code.selected')));
					return results;
				}
			}
			if ((XenosStringUtils.isBlank(lastEntryDateTimeFrom)) && (!(XenosStringUtils.isBlank(lastEntryDateTimeFromText))))
				{

					results.push(new ValidationResult(true, "lastEntryDateTimeFrom", "invalidFormat", Application.application.xResourceManager.getKeyValue('fam.notvalid.lastEntryDateTimeFrom.format')));
					
				}
			if ((XenosStringUtils.isBlank(lastEntryDateTimeTo)) && (!(XenosStringUtils.isBlank(lastEntryDateTimeToText))))
				{

					results.push(new ValidationResult(true, "lastEntryDateTimeTo", "invalidFormatlastEntryDateTimeTo", Application.application.xResourceManager.getKeyValue('fam.notvalid.lastEntryDateTimeTo.format')));
					
				}
			if (results.length > 0)
			    {
				    return results;
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
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionquery.from.tradedatelessthan.to.date')));
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
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionquery.from.valuedatelessthan.to.date')));
				}
			}

			for (i=0; i < settlementDateList.length; i++)
			{
			    obj = settlementDateList[i];
				input = obj[VALUE];
				label = obj[LABEL];
				
				if (DateUtils.isValidDate(StringUtil.trim(input)))
				{
					settlementDateObj[i]=dateformat.toDate(CustomDateFormatter.customizedInputDateString(input));

				}
				else
				{
					results.push(new ValidationResult(true, "toDate", ILLEGAL_DATE, Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.date', new Array([label],[input]))));
					
				}

			}

			for (var itr3:int=0; itr3 < settlementDateObj.length; itr3 += 2)
			{
				var comDate4:int=ObjectUtil.dateCompare(settlementDateObj[itr3], settlementDateObj[itr3 + 1]);
				// check Form Date not less than To Date
				if (comDate4 == 1)
				{
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionquery.from.settlementdatelessthan.to.date')));
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
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionquery.from.bookdatelessthan.to.date')));
				}
			}
			
						
			
			for (i=0; i < lastEntryDateList.length; i++)
			{
			
			    obj = lastEntryDateList[i];
				input = obj[VALUE];
				label = obj[LABEL];
				
				if (DateUtils.isValidDate(StringUtil.trim(input)))
				{
					lastEntryDateObj[i]=dateformat.toDate(CustomDateFormatter.customizedInputDateString(input));

				}
				else
				{
				    results.push(new ValidationResult(true, "toDate", ILLEGAL_DATE, Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.date', new Array([label],[input]))));
				}

			}

			for (var itr4:int=0; itr4 < lastEntryDateObj.length; itr4 += 2)
			{
				var comDate5:int=ObjectUtil.dateCompare(lastEntryDateObj[itr4], lastEntryDateObj[itr4 + 1]);
				// check Form Date not less than To Date
				if (comDate5 == 1)
				{
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionquery.from.lastentry.date.lessthan.to.date')));
				}
			}

			for (i=0; i < lastEntryDateTimeList.length; i++)
			{
				obj = lastEntryDateTimeList[i];
				input = obj[VALUE];
				label = obj[LABEL];				

				if (DateUtils.isValidDate(StringUtil.trim(input)))
				{
					lastEntryDateTimeObj[i]=dateformat.toDate(CustomDateFormatter.customizedInputDateString(input));

				}
				else
				{
					results.push(new ValidationResult(true, "toDate", ILLEGAL_DATE, Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.date', new Array([label],[input]))));
				}

			}

			for (var itr5:int=0; itr5 < lastEntryDateTimeObj.length; itr5 += 2)
			{
				var comDate6:int = ObjectUtil.dateCompare(lastEntryDateTimeObj[itr5], lastEntryDateTimeObj[itr5 + 1]);
				
				// check Form Date not less than To Date
				if (comDate6 == 1)
				{
					results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('fam.transactionquery.from.lastentry.datetime.lessthan.to.datetime')));
				}
				if (comDate6 == 0)
				{
					if (numFromHH == numToHH)
					{
						if (numFromMM == numToMM)
						{
							if (numFromSS > numToSS)
							{
								results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromSecondLessThantoSecond", Application.application.xResourceManager.getKeyValue('fam.transactionquery.from.lastentry.timeSecond.lessthan.to.timesecond')));
							}


						}
						else if (numFromMM > numToMM)
						{
							results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromMinuteLessThantoMinute", Application.application.xResourceManager.getKeyValue('fam.transactionquery.from.lastentry.timeminute.lessthan.to.timeminute')));
						}


					}
					else if (numFromHH > numToHH)
					{
						results.push(new ValidationResult(true, XenosStringUtils.EMPTY_STR, "fromHoursLessThantoHours", Application.application.xResourceManager.getKeyValue('fam.transactionquery.from.lastentry.timehours.lessthan.to.timehours')));
					}
				}
					
			}
			return results;
		}

    }
}