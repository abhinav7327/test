package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class InstrumentGeneralInfoValidator extends Validator
	{
		public var results:Array=[];
		
		public function InstrumentGeneralInfoValidator()
		{
			super();
		}

        protected override function doValidation(value:Object):Array {        	
           
            var contractSizeStr:String = "";
            var countryCodeStr:String = "";
            var issueCcyStr:String = "";
            var minTradingUnitStr:String = "";
            var listedIdStr:String = "";
            var priceTypeStr:String = "";
            var shortNameStr:String = "";
            var officialNameStr:String = "";
            var instrumentTypeStr:String = "";
            var displaySequenceStr:String = "";
            var invsetmentCountryCodeStr:String ="";
            
            if (value != null) {
            	
            	try
            	{
            		instrumentTypeStr = StringUtil.trim(value['instrumentType']);
	            	contractSizeStr = StringUtil.trim(value['contractSize']);
	            	countryCodeStr = StringUtil.trim(value['countryCode']);
	            	issueCcyStr = StringUtil.trim(value['issueCcy']);
	            	minTradingUnitStr = StringUtil.trim(value['minTradingUnit']);
	            	listedIdStr = StringUtil.trim(value['listedId']);
	            	priceTypeStr = StringUtil.trim(value['priceType']);
	            	shortNameStr = StringUtil.trim(value['shortName']);
	            	officialNameStr = StringUtil.trim(value['officialName']);
	            	displaySequenceStr = StringUtil.trim(value['displaySequence']);
	            	invsetmentCountryCodeStr =StringUtil.trim(value['investmentCountryCode']);
            	}
            	catch(e:Error)
            	{
            		trace(e);
            	}
            }
            
            var isInstrumentCcyType:Boolean = instrumentTypeStr == "CCY" ? true : false;
            
            if (XenosStringUtils.isBlank(contractSizeStr)) {
            	results.push(new ValidationResult(true, 
                    "contractSize", "contractSize", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.contractsizeempty')));
			}
			            
            if (XenosStringUtils.isBlank(countryCodeStr) && !isInstrumentCcyType){
            	results.push(new ValidationResult(true, 
                    "countryCode", "countryCode", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.countrycodeempty')));
			}
			if (XenosStringUtils.isBlank(invsetmentCountryCodeStr) && !isInstrumentCcyType){
            	results.push(new ValidationResult(true, 
                    "investmentCountryCode", "investmentCountryCode", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.investmentcountrycodeempty')));
			}
			
            if (XenosStringUtils.isBlank(issueCcyStr) && !isInstrumentCcyType){
            	results.push(new ValidationResult(true, 
                    "issueCcy", "issueCcy", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.issuecurrenceempty')));
			}
			
			if (XenosStringUtils.isBlank(displaySequenceStr) && isInstrumentCcyType){
            	results.push(new ValidationResult(true, 
                    "displaySequence", "displaySequence", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.displaysequenceempty')));
			}
			
            if (XenosStringUtils.isBlank(minTradingUnitStr) && isInstrumentCcyType){
            	results.push(new ValidationResult(true, 
                    "minTradingUnit", "minTradingUnit", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.minimumtradeunitempty')));
			} 
			
            if (XenosStringUtils.isBlank(listedIdStr)){
            	results.push(new ValidationResult(true, 
                    "listedId", "listedId", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.listidempty')));
			}
			
            if (XenosStringUtils.isBlank(priceTypeStr)){
            	results.push(new ValidationResult(true, 
                    "priceType", "priceType", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.pricetypeempty')));
			}	
			
			if (XenosStringUtils.isBlank(shortNameStr)){
            	results.push(new ValidationResult(true, 
                    "shortName", "shortName", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.instrumentshortnameempty')));
			}	
			
			if (XenosStringUtils.isBlank(officialNameStr)){
            	results.push(new ValidationResult(true, 
                    "officialName", "officialName", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.officialintrumentnameempty')));
			}
			
            if (XenosStringUtils.isBlank(instrumentTypeStr)){
            	results.push(new ValidationResult(true, 
                    "instrumentType", "noinstrumentType",Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.instrumenttypeempty')));
			}													
			
			return results;
        }
		
	}
}