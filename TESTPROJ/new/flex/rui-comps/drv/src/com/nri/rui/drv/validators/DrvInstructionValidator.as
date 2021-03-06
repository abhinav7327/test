
package com.nri.rui.drv.validators {
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import com.nri.rui.drv.DrvConstants;
	import com.nri.rui.core.utils.XenosStringUtils;
    
    /**
     * Custom Validator for Derivative Instruction Query
     */	
	public class DrvInstructionValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        
        
		public function DrvInstructionValidator()
		{
			super();
		}
		
	      
        protected override function doValidation(value:Object):Array
        {
        	if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('drv.alert.value.object.null'));
                return null;
            }
            
        	var trddatefrom:Date = null;
        	var tradedateto:Date = null;
	 		var valuedatefrom:Date = null;
	 		var valuedateto:Date = null; 
			var transdate:Date = null;
			var operationObj:String = "";
			//XenosAlert.info("value.trdDateFrom1" + value.trdDateFrom);
		    var dateformat:CustomDateFormatter = new CustomDateFormatter();
			results = [];
        	results = super.doValidation(value);
        	
        	if(XenosStringUtils.equals(value.operationObj , DrvConstants.QUERY)){
        		if(XenosStringUtils.isBlank(value.trdDateFrom)
        			&& XenosStringUtils.isBlank(value.trdDateTo)
				    && XenosStringUtils.isBlank(value.valueDateFrom)
				    && XenosStringUtils.isBlank(value.valueDateTo)
				    && XenosStringUtils.isBlank(value.transDate)){
				    	
				     results.push(new ValidationResult(true, 
		                "missingAllDate", "missingAllDate", Application.application.xResourceManager.getKeyValue('drv.error.missing.date') + value.valueDateTo));
		        	return results;	
        		}
        	}
        	
			
			dateformat.formatString = "YYYYMMDD";
			var formatData:String = "";
        	formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.trdDateFrom));
        	
        	if( value.trdDateFrom != "" ){ 
		    	if(DateUtils.isValidDate(StringUtil.trim(value.trdDateFrom))){
		             trddatefrom=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.trdDateFrom));
		        }else{
		             results.push(new ValidationResult(true, 
		                "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('drv.validator.illegal.dateformat') + value.trdDateFrom));
		        	return results;
		        }
	        }
	        
	        if(value.trdDateTo != "" ){ 
		        if(DateUtils.isValidDate(StringUtil.trim(value.trdDateTo))) {
		             tradedateto=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.trdDateTo));
		        }else{
		             results.push(new ValidationResult(true, 
		                "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('drv.validator.illegal.dateformat') + value.trdDateTo));
		        	return results;
		        }
	        }
	        
	        if(value.valueDateFrom != ""){
		        if(DateUtils.isValidDate(StringUtil.trim(value.valueDateFrom))) {
		             valuedatefrom=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.valueDateFrom));
		        }else{
		             results.push(new ValidationResult(true, 
		                "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('drv.validator.illegal.dateformat') + value.valueDateFrom));
		        	return results;
		        }
	        }
	        
	        if(value.valueDateTo != ""){
		        if(DateUtils.isValidDate(StringUtil.trim(value.valueDateTo))) {
		             valuedateto=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.valueDateTo));
		        }else{
		             results.push(new ValidationResult(true, 
		                "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('drv.validator.illegal.dateformat') + value.valueDateTo));
		        	return results;
		        }
	        }
	        
	        if(value.transDate != ""){
		        if(DateUtils.isValidDate(StringUtil.trim(value.transDate))) {
		             transdate=dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.transDate));
		        }else{
		             results.push(new ValidationResult(true, 
		                "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('drv.validator.illegal.dateformat') + value.transDate));
		        	return results;
		        }
	        }
	        
	        if((value.trdDateFrom != "") && (value.trdDateTo != "")){
		        if(ObjectUtil.dateCompare(trddatefrom,tradedateto) == 1){
		        	results.push(new ValidationResult(true,
		        			"", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('drv.error.date.compare')));
		        	return results;
		        }
	        }
	        
	        if((value.valueDateFrom != "") && (value.valuedateto != "")){
		        if(ObjectUtil.dateCompare(valuedatefrom,valuedateto) == 1){
		        	results.push(new ValidationResult(true,
		        			"", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('drv.error.date.compare')));
		        	return results;
		        }
	        }
			return results;
        }

	}
}