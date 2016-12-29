
package com.nri.rui.smr.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosStringUtils;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;


	public class QueryBloombergDataValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results : Array;
        
		public function QueryBloombergDataValidator()
		{
			super();
		}
		
		/**
         * validate entitlement query form
         */ 
        protected override function doValidation(value : Object) : Array
        {
        	if (value == null) {
                XenosAlert.info("value object is null");
                return null;
            }
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                 
            // Return if there are errors.
            if (results.length > 0)
                return results;

            var dateList:Array = [];
            var ticker:String = value.ticker;
            var isin:String = value.isin;
            var cusip:String = value.cusip;
            var sedol:String = value.sedol;
            var	exchangeCode:String = value.exchangeCode;
	   		var	issueCountry:String = value.issueCountry;
	   		var	issueCcy:String  = value.issueCcy;
	   		var	IssueDateFrom:String  = value.IssueDateFrom;
	   		var	IssueDateTo:String  = value.IssueDateTo;
	   		var	maturityDateFrom:String = value.maturityDateFrom;
	   		var	maturityDateTo:String = value.maturityDateTo;
	   		var	securityName:String  = value.securityName;
//	   		var	securityType:String  = value.securityType;
            var	marketSector:String  = value.marketSector;
            
        	if(value.IssueDateFrom != "")
        		dateList.push(value.IssueDateFrom);
            if(value.IssueDateTo != "")
            	dateList.push(value.IssueDateTo);
            
            if(value.maturityDateFrom != "")
            	dateList.push(value.maturityDateFrom);
            if(value.maturityDateTo != "")
            	dateList.push(value.maturityDateTo);

            
            if(XenosStringUtils.isBlank(ticker) && XenosStringUtils.isBlank(isin) &&
               XenosStringUtils.isBlank(cusip) && XenosStringUtils.isBlank(sedol) &&
               XenosStringUtils.isBlank(exchangeCode) && XenosStringUtils.isBlank(issueCountry) &&
               XenosStringUtils.isBlank(issueCcy) && XenosStringUtils.isBlank(IssueDateFrom) &&
               XenosStringUtils.isBlank(IssueDateTo) && XenosStringUtils.isBlank(maturityDateFrom) &&
               XenosStringUtils.isBlank(maturityDateTo) && XenosStringUtils.isBlank(securityName) &&
               XenosStringUtils.isBlank(marketSector)){
               results.push(new ValidationResult(true, 
		"secCode", "blankSecCode", Application.application.xResourceManager.getKeyValue('smr.error.blank.searchData')));
            }
            
             var dateformat:CustomDateFormatter =new CustomDateFormatter();
            //format of the date
            dateformat.formatString="YYYYMMDD";
            var formatData:String ="";
            
            var dateObj:Array = [];
            
            for(var iterator:int=0; iterator<dateList.length; iterator++) {
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
	            if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator]))) {
		           dateObj[iterator] = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator]));
		            }else {
		            	results.push(new ValidationResult(true, 
		                    "toDate", "illegaltoDate", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + dateList[iterator]));
		                return results;
		            }
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2) {
            	var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
	            // check From Date not less than To Date
	            if (comDate==1) {
	                results.push(new ValidationResult(true, 
	                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.fromtodatecomparision')));
	            }
            }                         
            return results;
        }
	}
}