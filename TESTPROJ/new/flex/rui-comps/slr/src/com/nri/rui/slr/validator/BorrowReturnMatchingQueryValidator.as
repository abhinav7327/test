// ActionScript file


package com.nri.rui.slr.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	public class BorrowReturnMatchingQueryValidator extends Validator
	{
	 private var results:Array;
		public function BorrowReturnMatchingQueryValidator()
		{
			super();
		}
		
		/**
         * 
         * validate movement query form
         */ 
       
        protected override function doValidation(value:Object):Array {
			
			var dateList:Array = [];
            
        	var borrowTdFrom:Date =null;
        	var borrowTdTo:Date = null;
        	var borrowVdFrom:Date = null;
        	var borrowVdTo:Date = null;
        	var returnTdFrom:Date = null;
        	var returnTdTo:Date = null;
        	var returnVdFrom:Date = null;
        	var returnVdTo:Date = null;
        	var matchDt:Date = null;
        	
        	var dateformat:CustomDateFormatter = new CustomDateFormatter();
        	// Clear results Array.
            results = [];
			
            // Call base class's doValidation().
            results = super.doValidation(value);
        	
        	//format of the date
            dateformat.formatString="YYYYMMDD";
            var formatData:String ="";
        	
        	if(value.btTdFrom != "") {
        		if(DateUtils.isValidDate(StringUtil.trim(value.btTdFrom))){
		             borrowTdFrom=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.btTdFrom));
		        }else{
		             results.push(new ValidationResult(true, 
		                "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('sbr.illegal.datelist') + value.btTdFrom));
		        	return results;
		        }
        	}
        		
			if(value.btTdTo != "") {
        		if(DateUtils.isValidDate(StringUtil.trim(value.btTdTo))){
		             borrowTdTo=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.btTdTo));
		        }else{
		             results.push(new ValidationResult(true, 
		                "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('sbr.illegal.datelist') + value.btTdTo));
		        	return results;
		        }
        	}
        		
        	
        	if(value.btVdFrom != "") {
        		if(DateUtils.isValidDate(StringUtil.trim(value.btVdFrom))){
		             borrowVdFrom=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.btVdFrom));
		        }else{
		             results.push(new ValidationResult(true, 
		                "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('sbr.illegal.datelist') + value.btVdFrom));
		        	return results;
		        }
        	}
        		
        	if(value.btVdTo != "") {
        		if(DateUtils.isValidDate(StringUtil.trim(value.btVdTo))){
		             borrowVdTo=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.btVdTo));
		        }else{
		             results.push(new ValidationResult(true, 
		                "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('sbr.illegal.datelist') + value.btVdTo));
		        	return results;
		        }
        	}
        	
        	if(value.rtTdFrom != "") {
        		if(DateUtils.isValidDate(StringUtil.trim(value.rtTdFrom))){
		             returnTdFrom=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.rtTdFrom));
		        }else{
		             results.push(new ValidationResult(true, 
		                "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('sbr.illegal.datelist') + value.rtTdFrom));
		        	return results;
		        }
        	}
        		
        	if(value.rtTdTo != "") {
        		if(DateUtils.isValidDate(StringUtil.trim(value.rtTdTo))){
		             returnTdTo=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.rtTdTo));
		        }else{
		             results.push(new ValidationResult(true, 
		                "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('sbr.illegal.datelist') + value.rtTdTo));
		        	return results;
		        }
        	}
        		
        	if(value.rtVdFrom != "") {
        		if(DateUtils.isValidDate(StringUtil.trim(value.rtVdFrom))){
		             returnVdFrom=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.rtVdFrom));
		        }else{
		             results.push(new ValidationResult(true, 
		                "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('sbr.illegal.datelist') + value.rtVdFrom));
		        	return results;
		        }
        	}
        		
        	if(value.rtVdTo != "") {
        		if(DateUtils.isValidDate(StringUtil.trim(value.rtVdTo))){
		             returnVdTo=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.rtVdTo));
		        }else{
		             results.push(new ValidationResult(true, 
		                "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('sbr.illegal.datelist') + value.rtVdTo));
		        	return results;
		        }
        	}
        		
        	if(value.matchdate != "") {
        		if(DateUtils.isValidDate(StringUtil.trim(value.matchdate))){
		             matchDt=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.matchdate));
		        }else{
		             results.push(new ValidationResult(true, 
		                "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('sbr.illegal.datelist') + value.matchdate));
		        	return results;
		        }
        	}
        	
            if((value.btTdFrom != "") && (value.btTdTo != "")){
		        if(ObjectUtil.dateCompare(borrowTdFrom,borrowTdTo) == 1){
		        	results.push(new ValidationResult(true,
		        			"", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('sbr.invalid.fromtodate')));
		        	return results;
		        }
	        }
	        
	        if((value.btVdFrom != "") && (value.btVdTo != "")){
		        if(ObjectUtil.dateCompare(borrowVdFrom,borrowVdTo) == 1){
		        	results.push(new ValidationResult(true,
		        			"", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('sbr.invalid.fromtodate')));
		        	return results;
		        }
	        }
	        
	        if((value.rtTdFrom != "") && (value.rtTdTo != "")){
		        if(ObjectUtil.dateCompare(returnTdFrom,returnTdTo) == 1){
		        	results.push(new ValidationResult(true,
		        			"", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('sbr.invalid.fromtodate')));
		        	return results;
		        }
	        }
	        
	         if((value.rtVdFrom != "") && (value.rtVdTo != "")){
		        if(ObjectUtil.dateCompare(returnVdFrom,returnVdTo) == 1){
		        	results.push(new ValidationResult(true,
		        			"", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('sbr.invalid.fromtodate')));
		        	return results;
		        }
	        }
            
   		   if (value.fundCode==""){
   		   	 results.push(new ValidationResult(true, 
	                    "fundCode","fundCode",Application.application.xResourceManager.getKeyValue('borrow.error.fund.code.blank')));
   		   	
   		   }
   		   
   		   if(!value.matchStatus && !value.oustandStatus && !value.markMatch) {
   		   		results.push(new ValidationResult(true, 
	                    "matchStatus","matchStatus",Application.application.xResourceManager.getKeyValue('borrow.error.match.status.blank')));
   		   }
   		   
   		   if(!value.btTdFrom && !value.btTdTo && !value.rtTdFrom && !value.rtTdTo &&  !value.matchdate) {
   		   		results.push(new ValidationResult(true, 
	                    "","conditionalmandatorydate",Application.application.xResourceManager.getKeyValue('sbr.conditional.mandatory.input.date')));
   		   }
        	return results;
        }
		
	}
}

	
