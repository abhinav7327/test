
package com.nri.rui.smr.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class SecurityRegistrationEntryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results : Array;
        
		public function SecurityRegistrationEntryValidator()
		{
			super();
		}
		/**
         * validate security registration entry form
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
             
            var instrumentType:String = value.instrumentType;
            var issueccy:String = value.issueccy;
            var shortname:String = value.shortname;
            var offname:String = value.officialname;
            var countrycode:String = value.countrycode;
            var countrybbdom:String = value.countrybbdom;
           	var contractSizeStr:String = value.contractSize;
           	var altShortname:String = value.altShortname;
            var altOfficialName:String = value.altOfficialName;
            var parentNode:String = value.parentInstrumentType;
        	var drvStartDt:String =	value.drvStartDt;
        	var drvExpDt:String =	value.drvExpDt;
        	var drvTickSize:String =	value.drvTickSize;
        	var drvContractDt:String =	value.drvContractDt;
        	var drvUnderlyingSecurity:String =	value.drvUnderlyingSecurity;
            var drvStrikePrice:String =	value.drvStrikePrice;
            var drvOptFlag:String =	value.drvOptFlag;
            var drvCallPutFlag:String =	value.drvCallPutFlag;
            var investmentCountryCode:String = value.investmentCountryCode;
            if(XenosStringUtils.isBlank(instrumentType)){
            	results.push(new ValidationResult(true, 
            		"instrumentType", "blankInstrumentType", Application.application.xResourceManager.getKeyValue('smr.error.blank.instrumentType'))); 
            }else{
            	 var params:Array = instrumentType.split(":");
            	
            	if(params.length !=2){
            		results.push(new ValidationResult(true, 
            		"instrumentType", "invalidInstrumentType", Application.application.xResourceManager.getKeyValue('smr.error.invalid.instrumentType')));
            	}else if(XenosStringUtils.isBlank(parentNode)){
            		results.push(new ValidationResult(true, 
            		"parentNode", "invalidparentNode", Application.application.xResourceManager.getKeyValue('smr.error.invalid.instrumentType')));
            	} 
            }
            if(XenosStringUtils.isBlank(issueccy)){
            	results.push(new ValidationResult(true, 
            		"issueccy", "blankissueccy", Application.application.xResourceManager.getKeyValue('smr.error.blank.issueccy'))); 
            }
            if(XenosStringUtils.isBlank(shortname)){
            	results.push(new ValidationResult(true, 
            		"shortname", "blankshortname", Application.application.xResourceManager.getKeyValue('smr.error.blank.shortname'))); 
            }
             if(XenosStringUtils.isBlank(offname)){
            	results.push(new ValidationResult(true, 
            		"offname", "blankoffname", Application.application.xResourceManager.getKeyValue('smr.error.blank.offname'))); 
            }
            if(XenosStringUtils.isBlank(countrycode)){
            	results.push(new ValidationResult(true, 
            		"countrycode", "blankcountrycode", Application.application.xResourceManager.getKeyValue('smr.error.blank.countrycode'))); 
            }
            if(XenosStringUtils.isBlank(countrybbdom)){
         		results.push(new ValidationResult(true, 
            		"countrybbdom", "blankcountrybbdom", Application.application.xResourceManager.getKeyValue('smr.error.blank.countrycodebbdom'))); 
         	}
         	if(XenosStringUtils.isBlank(investmentCountryCode)){
         		results.push(new ValidationResult(true, 
            		"investmentcountrycode", "blankinvestmentcountrycode", Application.application.xResourceManager.getKeyValue('smr.error.blank.investmentcountrycode'))); 
         	}         	
         	if (XenosStringUtils.isBlank(contractSizeStr)) {
            	results.push(new ValidationResult(true, 
                    "contractSize", "contractSize", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.contractsizeempty')));
			}
			if (XenosStringUtils.isBlank(altShortname) && !XenosStringUtils.isBlank(altOfficialName)) {
         		results.push(new ValidationResult(true, 
                    "altShortname", "altShortname", Application.application.xResourceManager.getKeyValue('smr.error.blank.altShortnameOffName')));
         	}
			if (XenosStringUtils.isBlank(altOfficialName) && !XenosStringUtils.isBlank(altShortname)) {
         		results.push(new ValidationResult(true, 
                    "altShortname", "altShortname", Application.application.xResourceManager.getKeyValue('smr.error.blank.altShortnameOffName')));
			}
			if(!XenosStringUtils.isBlank(instrumentType) && !XenosStringUtils.isBlank(parentNode)){
				if(parentNode == "FUT" || parentNode=="OPT"){
					trace("parent:validator ::"+parentNode);
					if(XenosStringUtils.isBlank(drvStartDt)){
							results.push(new ValidationResult(true, 
            					"drvStartDt", "blankdrvStartDt", Application.application.xResourceManager.getKeyValue('smr.error.blank.drvStartDt')));
					}
					if(XenosStringUtils.isBlank(drvExpDt)){
							results.push(new ValidationResult(true, 
            					"drvExpDt", "blankdrvExpDt", Application.application.xResourceManager.getKeyValue('smr.error.blank.drvExpDt')));
					}
					if(XenosStringUtils.isBlank(drvContractDt) && parentNode == "FUT"){
							results.push(new ValidationResult(true, 
            					"drvContractDt", "blankdrvContractDt", Application.application.xResourceManager.getKeyValue('smr.error.blank.drvContractDt')));
					}
					if(XenosStringUtils.isBlank(drvTickSize) && parentNode == "FUT"){
							results.push(new ValidationResult(true, 
            					"drvTickSize", "blankdrvTickSize", Application.application.xResourceManager.getKeyValue('smr.error.blank.drvTickSize')));
					}					
					if(parentNode=="OPT"){
						if(XenosStringUtils.isBlank(drvStrikePrice)){
								results.push(new ValidationResult(true, 
	            					"drvStrikePrice", "blankdrvStrikePrice", Application.application.xResourceManager.getKeyValue('smr.error.blank.drvStrikePrice')));
						}
						if(XenosStringUtils.isBlank(drvOptFlag)){
								results.push(new ValidationResult(true, 
	            					"drvOptFlag", "blankdrvOptFlag", Application.application.xResourceManager.getKeyValue('smr.error.blank.drvOptFlag')));
						}
						if(XenosStringUtils.isBlank(drvCallPutFlag)){
								results.push(new ValidationResult(true, 
	            					"drvCallPutFlag", "blankdrvCallPutFlag", Application.application.xResourceManager.getKeyValue('smr.error.blank.drvCallPutFlag')));
						}
						if(XenosStringUtils.isBlank(drvUnderlyingSecurity)){
							results.push(new ValidationResult(true, 
            					"drvUnderlyingSecurity", "blankdrvUnderlyingSecurity", Application.application.xResourceManager.getKeyValue('smr.error.blank.drvUnderlyingSecurity')));
						}
					}
					
				}
			}
         	return results;       
        }
		
	}
}