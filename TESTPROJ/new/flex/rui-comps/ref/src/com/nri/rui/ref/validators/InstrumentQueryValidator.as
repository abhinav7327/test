// ActionScript file


package com.nri.rui.ref.validators{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
    
    /**
     * Custom Validator for Instrument Query Implementation.
     * 
     */
	 public class InstrumentQueryValidator extends Validator{
	 	// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function InstrumentQueryValidator() {
			super();
		}
		/**
         * 
         * validate instrument query form
         */ 
        protected override function doValidation(value:Object):Array {
        	// Clear results Array.
            results = [];
            // Call base class's doValidation().
            results = super.doValidation(value);
            // Return if there are errors.
            if (results.length > 0)
                return results;
                
            var dateList:Array = [];
            
        	if(value.issueDateFrom != "")
        		dateList.push(value.issueDateFrom);
            if(value.issueDateTo != "")
            	dateList.push(value.issueDateTo);
            
            if(value.maturityDateFrom != "")
            	dateList.push(value.maturityDateFrom);
            if(value.maturityDateTo != "")
            	dateList.push(value.maturityDateTo);
            	
            if(value.couponDateFrom != "")
        		dateList.push(value.couponDateFrom);
            if(value.couponDateTo != "")
            	dateList.push(value.couponDateTo);
            
            if(value.listedDateFrom != "")
            	dateList.push(value.listedDateFrom);
            if(value.listedDateTo != "")
            	dateList.push(value.listedDateTo);
          
            if(value.ipoPaymentDateFrom != "")
        		dateList.push(value.ipoPaymentDateFrom);
            if(value.ipoPaymentDateTo != "")
            	dateList.push(value.ipoPaymentDateTo);
            
            if(value.conversionStartDateFrom != "")
            	dateList.push(value.conversionStartDateFrom);
            if(value.conversionStartDateTo != "")
            	dateList.push(value.conversionStartDateTo);
            	
            if(value.conversionEndDateFrom != "")
        		dateList.push(value.conversionEndDateFrom);
            if(value.conversionEndDateTo != "")
            	dateList.push(value.conversionEndDateTo);
            
            if(value.publicOfferStartDateFrom != "")
            	dateList.push(value.publicOfferStartDateFrom);
            if(value.publicOfferStartDateTo != "")
            	dateList.push(value.publicOfferStartDateTo);
            	
        	if(value.publicOfferEndDateFrom != "")
            	dateList.push(value.publicOfferEndDateFrom);
            if(value.publicOfferEndDateTo != "")
            	dateList.push(value.publicOfferEndDateTo);
            	
            if(value.appRegiDateFrom != "")
        		dateList.push(value.appRegiDateFrom);
            if(value.appRegiDateTo != "")
            	dateList.push(value.appRegiDateTo);
            	
            if(value.appUpdDateFrom != "")
            	dateList.push(value.appUpdDateFrom);
            if(value.appUpdDateTo != "")
            	dateList.push(value.appUpdDateTo);
        	
        	if(value.contractStartDate != "")
            	dateList.push(value.contractStartDate);
            if(value.contractExpiryDate != "")
            	dateList.push(value.contractExpiryDate);
            	
            if(value.posStartDateFrom != "")
            	dateList.push(value.posStartDateFrom);
            if(value.posStartDateTo != "")
            	dateList.push(value.posStartDateTo);
            if(value.posEndDateFrom != "")
            	dateList.push(value.posEndDateFrom);
            if(value.posEndDateTo != "")
            	dateList.push(value.posEndDateTo);
        	
        	var flag:int=0;
            
            
            
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
            
           
          if((value.categoryTypes != null && value.categoryTypes != " " &&
	    	(value.categoryIds == null || value.categoryIds == " ")) ||
	   		(value.categoryIds != null && value.categoryIds != " " &&
	   		 (value.categoryTypes == null || value.categoryTypes == " ")) )
		{
		 results.push(new ValidationResult(true, 
	                     "", "", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.category')));
		
		}
            
          // Contract Expiry Date and Contract Start Date 
            /* if(value.contractStartDate != "")
            	dateList.push(value.contractStartDate);
            if(value.contractExpiryDate != "")
            	dateList.push(value.contractExpiryDate); */
            //Date Format Validation
           
        	
        	
        	return results;
        }
		
	 }
}