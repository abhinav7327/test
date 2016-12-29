package com.nri.rui.swp.validator
{
	import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    
    import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;

	public class MarketValueEntryValidator extends Validator
	{
		public var results:Array=[];
		
		public function MarketValueEntryValidator()
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
            
            var contractReferenceNo:String = StringUtil.trim(queryModel.contractReferenceNo);
            var baseDate:String = StringUtil.trim(queryModel.baseDate);
            var marketValue:String = StringUtil.trim(queryModel.marketValue);
            var currency:String = StringUtil.trim(queryModel.currency); 
            
            var dateformat:CustomDateFormatter = new CustomDateFormatter();
            dateformat.formatString="YYYYMMDD";
            
            if(baseDate != ""){
                if(DateUtils.isValidDate(StringUtil.trim(baseDate))){
                    var objBaseDate:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(baseDate))                 
                }else{
                    results.push(new ValidationResult(true, "baseDate", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.illegalDateFormat') + baseDate));
                    return results;                 
                }
            }
            
            if(contractReferenceNo == null || StringUtil.trim(contractReferenceNo) == "")
            {
            	results.push(new ValidationResult(true,"contractReferenceNo", "contractReferenceNoMissing", Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.entry.contractReferenceNoMissing')));
            }
            
            if(baseDate == null || StringUtil.trim(baseDate) == "")
            {
                results.push(new ValidationResult(true,"baseDate", "baseDateMissing", Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.entry.baseDateMissing')));
            }
            
            if(marketValue == null || StringUtil.trim(marketValue) == "")
            {
                results.push(new ValidationResult(true,"marketValue", "marketValueMissing", Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.entry.marketValueMissing')));
            }
            
            if(currency == null || StringUtil.trim(currency) == "")
            {
                results.push(new ValidationResult(true,"currency", "currencyMissing", Application.application.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.entry.currencyMissing')));
            }
            
            return results;
		}
	}
}