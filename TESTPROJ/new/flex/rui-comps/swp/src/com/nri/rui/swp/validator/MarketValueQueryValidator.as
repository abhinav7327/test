package com.nri.rui.swp.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.NumberUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class MarketValueQueryValidator extends Validator
	{
		public var results:Array=[];
		
		public function MarketValueQueryValidator()
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
            
            // Initialize all requisite arrays and variables
            var dateObj:Array = [];
            var dateList:Array = [];
            var formatData:String = "";
            var dateformat:CustomDateFormatter = new CustomDateFormatter();
            dateformat.formatString="YYYYMMDD";
            
            
            // Retrieve all the validation conditions from the queryModel object (and push the dates in the dateList array) 
             var baseDateFrom:String = StringUtil.trim(queryModel.baseDateFrom);
            //dateList.push(baseDateFrom);
            var baseDateTo:String = StringUtil.trim(queryModel.baseDateTo);
            //dateList.push(baseDateTo);
            
            var tradeDateFrom:String = StringUtil.trim(queryModel.tradeDateFrom);
            //dateList.push(tradeDateFrom);
            var tradeDateTo:String = StringUtil.trim(queryModel.tradeDateTo);
            //dateList.push(tradeDateTo);
            
            var maturityDateFrom:String = StringUtil.trim(queryModel.maturityDateFrom);
            //dateList.push(maturityDateFrom);
            var maturityDateTo:String = StringUtil.trim(queryModel.maturityDateTo);
            //dateList.push(maturityDateTo);
            
            var terminationDateFrom:String = StringUtil.trim(queryModel.terminationDateFrom);
            //dateList.push(terminationDateFrom);
            var terminationDateTo:String = StringUtil.trim(queryModel.terminationDateTo);
            //dateList.push(terminationDateTo); 
            
            var objBaseDateFrom 			: 	Date = 	null ;
            var objBaseDateTo   			: 	Date = 	null ;
            var objTradeDateFrom 			: 	Date = 	null ;
            var objTradeDateTo   			: 	Date = 	null ;
            var objMaturityDateFrom			:	Date =	null ;
            var objMaturityDateTo			:	Date =	null ;
            var objTerminationDateFrom		:	Date =	null ;
            var objTerminationDateTo		:	Date =	null ;
                        
            //var notionalAmountFrom:String = StringUtil.trim(queryModel.notionalAmountFrom);            
            //var notionalAmountTo:String = StringUtil.trim(queryModel.notionalAmountTo);
            
            // A. Check for illegal date formats
            
            
            if(baseDateFrom != ""){
                if(DateUtils.isValidDate(StringUtil.trim(baseDateFrom))){                    
                    //dateObj.push(dateformat.toDate(CustomDateFormatter.customizedInputDateString(baseDateFrom)));
                    objBaseDateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(baseDateFrom));                 
                }else{
                    results.push(new ValidationResult(true, "baseDateFrom", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.illegalDateFormat') + baseDateFrom));
                    return results;                 
                }
            }
            
            if(baseDateTo != ""){
                if(DateUtils.isValidDate(StringUtil.trim(baseDateTo))){                    
                    //dateObj.push(dateformat.toDate(CustomDateFormatter.customizedInputDateString(baseDateTo)));                 
                    objBaseDateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(baseDateTo));
                }else{
                    results.push(new ValidationResult(true, "baseDateTo", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.illegalDateFormat')+ " " + baseDateTo));
                    return results;                 
                }
            }
            
            if(tradeDateFrom != ""){
                if(DateUtils.isValidDate(StringUtil.trim(tradeDateFrom))){                    
                    //dateObj.push(dateformat.toDate(CustomDateFormatter.customizedInputDateString(tradeDateFrom)));                 
                    objTradeDateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(tradeDateFrom));
                }else{
                    results.push(new ValidationResult(true, "tradeDateFrom", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.illegalDateFormat') + " " + tradeDateFrom));
                    return results;                 
                }
            }
            
            if(tradeDateTo != ""){
                if(DateUtils.isValidDate(StringUtil.trim(tradeDateTo))){                    
                    //dateObj.push(dateformat.toDate(CustomDateFormatter.customizedInputDateString(tradeDateTo)));                 
                    objTradeDateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(tradeDateTo));
                }else{
                    results.push(new ValidationResult(true, "tradeDateTo", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.illegalDateFormat') + " " + tradeDateTo));
                    return results;                 
                }
            }
            
            if(maturityDateFrom != ""){
                if(DateUtils.isValidDate(StringUtil.trim(maturityDateFrom))){                    
                    //dateObj.push(dateformat.toDate(CustomDateFormatter.customizedInputDateString(maturityDateFrom)));                 
                    objMaturityDateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(maturityDateFrom));
                }else{
                    results.push(new ValidationResult(true, "maturityDateFrom", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.illegalDateFormat') + " " + maturityDateFrom));
                    return results;                 
                }
            }
            
            if(maturityDateTo != ""){
                if(DateUtils.isValidDate(StringUtil.trim(maturityDateTo))){                    
                    //dateObj.push(dateformat.toDate(CustomDateFormatter.customizedInputDateString(maturityDateTo)));                 
                    objMaturityDateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(maturityDateTo));
                }else{
                    results.push(new ValidationResult(true, "maturityDateTo", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.illegalDateFormat') + " " + maturityDateTo));
                    return results;                 
                }
            }
            
            if(terminationDateFrom != ""){
                if(DateUtils.isValidDate(StringUtil.trim(terminationDateFrom))){                    
                    //dateObj.push(dateformat.toDate(CustomDateFormatter.customizedInputDateString(terminationDateFrom)));                 
                    objTerminationDateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(terminationDateFrom));
                }else{
                    results.push(new ValidationResult(true, "terminationDateFrom", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.illegalDateFormat') + " " + terminationDateFrom));
                    return results;                 
                }
            }
            
            if(terminationDateTo != ""){
                if(DateUtils.isValidDate(StringUtil.trim(terminationDateTo))){                    
                    //dateObj.push(dateformat.toDate(CustomDateFormatter.customizedInputDateString(terminationDateTo)));                 
                    objTerminationDateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(terminationDateTo));
                }else{
                    results.push(new ValidationResult(true, "terminationDateTo", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.illegalDateFormat') + " " + terminationDateTo));
                    return results;                 
                }
            }
            
            
            // B. Check for range validation (to less than from)
            if((objBaseDateFrom != null) && (objBaseDateTo != null)) {
				if(ObjectUtil.dateCompare(objBaseDateTo,objBaseDateFrom) == -1){
	        		results.push(new ValidationResult(true, 
	                    "", "baseDateToShouldNotLessThenBaseDateFrom",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validation.baseDateToLessThanBaseDateFrom')));
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
            /* for(var itr:int=0; itr<dateObj.length; itr+=2){
                var comDate:int=ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);                
                if (comDate==1) {
                    results.push(new ValidationResult(true, "", "fromDateLessThantoDate",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.fromtodate')));
                }
            } */
            
            /* var myPattern:RegExp = /,/g;
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
            } */
                
            return results;
		}
		
	}
}