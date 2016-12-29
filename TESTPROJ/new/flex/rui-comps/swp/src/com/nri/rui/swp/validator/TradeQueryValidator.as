package com.nri.rui.swp.validator
{
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import mx.utils.ObjectUtil;
	import com.nri.rui.core.utils.NumberUtils ;

	public class TradeQueryValidator extends Validator
	{
		public var results:Array=[];
		
		public function TradeQueryValidator()
		{
			super();
		}
		
		protected override function doValidation(queryModel:Object):Array
        {   
            results = super.doValidation(queryModel);            
            if (results.length > 0)
            {
                return results;             
            }
            
            var dateformat:CustomDateFormatter = new CustomDateFormatter();
            dateformat.formatString="YYYYMMDD";
            
            var tradeDateFrom:String = StringUtil.trim(queryModel.tradeDateFrom);
            var tradeDateTo:String = StringUtil.trim(queryModel.tradeDateTo);
            var maturityDateFrom:String = StringUtil.trim(queryModel.maturityDateFrom);
            var maturityDateTo:String = StringUtil.trim(queryModel.maturityDateTo);
            var terminationDateFrom:String = StringUtil.trim(queryModel.terminationDateFrom);
            var terminationDateTo:String = StringUtil.trim(queryModel.terminationDateTo);
            
            var objTradeDateFrom 			: 	Date = 	null ;
            var objTradeDateTo   			: 	Date = 	null ;
            var objMaturityDateFrom			:	Date =	null ;
            var objMaturityDateTo			:	Date =	null ;
            var objTerminationDateFrom		:	Date =	null ;
            var objTerminationDateTo		:	Date =	null ;
            var notionalAmountFrom          :   String  =  StringUtil.trim(queryModel.notionalAmountFrom);
            var notionalAmountTo	        :   String  =  StringUtil.trim(queryModel.notionalAmountTo);
            
            
            if(tradeDateFrom != ""){
            	if(DateUtils.isValidDate(StringUtil.trim(tradeDateFrom))){
                    objTradeDateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(tradeDateFrom))                 
                } else {
                    results.push(new ValidationResult(true, "tradeDateFrom", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swptradequery.validator.illegalDateFormat') + tradeDateFrom));
                    return results;                 
                }
            }
            
            if(tradeDateTo != ""){
            	if(DateUtils.isValidDate(StringUtil.trim(tradeDateTo))){
                    objTradeDateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(tradeDateTo))                 
                }else{
                    results.push(new ValidationResult(true, "tradeDateTo", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swptradequery.validator.illegalDateFormat') + tradeDateTo));
                    return results;                 
                }
            }
                        
            if(maturityDateFrom != ""){
            	if(DateUtils.isValidDate(StringUtil.trim(maturityDateFrom))){
                    objMaturityDateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(maturityDateFrom))                 
                }else{
                    results.push(new ValidationResult(true, "maturityDateFrom", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swptradequery.validator.illegalDateFormat') + maturityDateFrom));
                    return results;                 
                }
            }
            
            if(maturityDateTo != ""){
            	if(DateUtils.isValidDate(StringUtil.trim(maturityDateTo))){
                    objMaturityDateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(maturityDateTo))                 
                }else{
                    results.push(new ValidationResult(true, "maturityDateTo", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swptradequery.validator.illegalDateFormat') + maturityDateTo));
                    return results;                 
                }
            }
            
            if(terminationDateFrom != ""){
            	if(DateUtils.isValidDate(StringUtil.trim(terminationDateFrom))){
                    objTerminationDateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(terminationDateFrom))                 
                }else{
                    results.push(new ValidationResult(true, "terminationDateFrom", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swptradequery.validator.illegalDateFormat') + terminationDateFrom));
                    return results;                 
                }
            }
            
            if(terminationDateTo != ""){
            	if(DateUtils.isValidDate(StringUtil.trim(terminationDateTo))){
                    objTerminationDateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(terminationDateTo))                 
                }else{
                    results.push(new ValidationResult(true, "terminationDateTo", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swptradequery.validator.illegalDateFormat') + terminationDateTo));
                    return results;                 
                }
            }
            
            if((objTradeDateFrom != null) && (objTradeDateTo != null)) {
				if(ObjectUtil.dateCompare(objTradeDateTo,objTradeDateFrom) == -1){
	        		results.push(new ValidationResult(true, 
	                    "", "tradeDateToShouldNotLessThenTradeDateFrom",  Application.application.xResourceManager.getKeyValue('swp.swptradequery.validation.tradeDateToLessThanTradeDateFrom')));
	        	}
			}
            
            if((objMaturityDateFrom != null) && (objMaturityDateTo != null)) {
				if(ObjectUtil.dateCompare(objMaturityDateTo,objMaturityDateFrom) == -1){
	        		results.push(new ValidationResult(true, 
	                    "", "maturityDateToShouldNotLessThenMaturityDateFrom",  Application.application.xResourceManager.getKeyValue('swp.swptradequery.validation.maturityDateToLessThanMaturityDateFrom')));
	        	}
			}
			
			if((objTerminationDateFrom != null) && (objTerminationDateTo != null)) {
				if(ObjectUtil.dateCompare(objTerminationDateTo,objTerminationDateFrom) == -1){
	        		results.push(new ValidationResult(true, 
	                    "", "terminationDateToShouldNotLessThenTerminationDateFrom",  Application.application.xResourceManager.getKeyValue('swp.swptradequery.validation.terminationDateToLessThanTerminationDateFrom')));
	        	}
			}
			
			var myPattern:RegExp = /,/g;
			
			
			if (notionalAmountFrom != null && notionalAmountFrom != '') {
            	notionalAmountFrom = notionalAmountFrom.replace(myPattern , "");
            	if(!NumberUtils.checkValidNumber(notionalAmountFrom)){
            		results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.swptradequery.validation.invalidNotionalAmountFrom')+" "+notionalAmountFrom));
            	}
				
			}
            	
            if (notionalAmountTo != null && notionalAmountTo != '') {
            	notionalAmountTo = notionalAmountTo.replace(myPattern , "");
            	if(!NumberUtils.checkValidNumber(notionalAmountTo)){
            		results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.swptradequery.validation.invalidNotionalAmountTo')+" "+notionalAmountTo));
            	}
            	
            }
            
            if (notionalAmountFrom != null && notionalAmountFrom != ''
                && notionalAmountTo != null && notionalAmountTo != '') {
            	if ((Number)(notionalAmountFrom) > (Number)(notionalAmountTo)) {
            		results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.swptradequery.validation.notionalAmountFromShouldLessThanNotionalAmountTo')));
            	}
            }
			
			
							
			
            /*
            // Validation for value date to be greater than Trade date
            if(valueDate != "" && tradeDateFrom != ""){            	
            	var compInt1:int = ObjectUtil.dateCompare(objTradeDateFrom, objValueDate);
                if(compInt1 == 1){
                    results.push(new ValidationResult(true, "valueDate", "valueDateLessThantradeDate", Application.application.xResourceManager.getKeyValue('swp.swptradequery.validator.valueDateLessThanTradeDate')));
                }
            }
            
            // Validation for Maturity date to be greater than Value date
            if(maturityDate != "" && valueDate != ""){            	
            	var compInt2:int = ObjectUtil.dateCompare(objValueDate, objMaturityDate);
                if(compInt2 == 1){
                    results.push(new ValidationResult(true, "maturityDate", "maturityDateLessThanvalueDate", Application.application.xResourceManager.getKeyValue('swp.swptradequery.validator.maturityDateLessThanValueDate')));
                }
            }
            */  
            return results;
        }
		
	}
}