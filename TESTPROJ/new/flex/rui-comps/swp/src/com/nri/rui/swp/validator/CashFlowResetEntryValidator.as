package com.nri.rui.swp.validator
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class CashFlowResetEntryValidator extends Validator
	{
		public var results:Array=[];
		
		public function CashFlowResetEntryValidator()
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
            
            var resetDate:String = StringUtil.trim(queryModel.resetDate);
            var resetRate:String = StringUtil.trim(queryModel.resetRate);
            var resetRateNum:Number = Number(resetRate);
            
            
            var dateformat:CustomDateFormatter = new CustomDateFormatter();
            dateformat.formatString="YYYYMMDD";
            
            if(resetDate != ""){
                if(DateUtils.isValidDate(StringUtil.trim(resetDate))){
                    var objResetDate:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(resetDate))                 
                }else{
                    results.push(new ValidationResult(true, "resetDate", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swpcashflowquery.validator.illegalDateFormat') + resetDate));
                    return results;                 
                }
            }
            
            if(resetRate == null || StringUtil.trim(resetRate) == "")
            {
                results.push(new ValidationResult(true,"resetRate", "resetRateMissing", Application.application.xResourceManager.getKeyValue('swp.swpcashflowquery.validator.entry.resetRateMissing')));
            }
            
            
            if(resetRateNum < 0 || resetRateNum > 100)
            {
                results.push(new ValidationResult(true,"resetRate", "resetRateMissing", Application.application.xResourceManager.getKeyValue('swp.swpcashflowquery.validator.entry.invalidResetRate')));	
            }
            
            return results;
		}
	}
}