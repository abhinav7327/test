package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class InstrumentDeribativesValidator extends Validator
	{
		private var results:Array;
		
		public function InstrumentDeribativesValidator()
		{
			super();
		}

        protected override function doValidation(value:Object):Array {
        	
            results = [];
       
            var contractStartDateStr:String = "";
            var contractExpiryDateStr:String = "";
            /*var tickSizeStr:String = "";
            var underlyingInstrumentCode:String = "";
            var drvSettlementType:String = "";
            var callPutFlag:String = "";
            var optionType:String = "";
            var strikePriceStr:String = "";
            var parentInstrumentType:String = "";*/

            var validDate1:Boolean = false;
 			var validDate2:Boolean = false;
 			var compareResult:Number = 1;
            
            if (value != null) {
            	
            	try
            	{
            		
            		//parentInstrumentType = StringUtil.trim(value['parentInstrumentType']);
            		contractStartDateStr = StringUtil.trim(value['contractStartDateStr']);
              		contractExpiryDateStr = StringUtil.trim(value['contractExpiryDateStr']);
              		//underlyingInstrumentCode = StringUtil.trim(value['underlyingInstrumentCode']);
              		
            		/*if(parentInstrumentType == 'OPT' || parentInstrumentType == 'CO' ||parentInstrumentType == 'BO' ||
            		parentInstrumentType == 'SO' ||parentInstrumentType == 'IRO' ){
            			||parentInstrumentType == 'BF' || 
            		parentInstrumentType == 'SIF' || parentInstrumentType == 'IRF' || parentInstrumentType == 'CF' || parentInstrumentType == 'SF' 
            		|| parentInstrumentType == 'BIF'*/
            			//mandatory fields tickSizeStr,drvSettlementType,callPutFlag
            			//,optionType,strikePriceStr
            			
            			/*tickSizeStr = StringUtil.trim(value['tickSizeStr']);
            			drvSettlementType = StringUtil.trim(value['drvSettlementType']);
            			callPutFlag = StringUtil.trim(value['callPutFlag']);
            			optionType = StringUtil.trim(value['optionType']);
            			strikePriceStr = StringUtil.trim(value['strikePriceStr']);
            			
            			if (XenosStringUtils.isBlank(tickSizeStr)){
			            	results.push(new ValidationResult(true, 
			                    "tickSizeStr", "notickSizeStr", "Tick Size is Mandatory for InstrumentType ["+ parentInstrumentType + "]"));
						}
						if (XenosStringUtils.isBlank(drvSettlementType)){
			            	results.push(new ValidationResult(true, 
			                    "drvSettlementType", "nodrvSettlementType", "Derivative Serttlement Type is Mandatory for InstrumentType ["+ parentInstrumentType + "]"));
						}
						
						if (XenosStringUtils.isBlank(callPutFlag)){
			            	results.push(new ValidationResult(true, 
			                    "callPutFlag", "nocallPutFlag", "Call Put Flag is Mandatory for InstrumentType ["+ parentInstrumentType + "]"));
						}
						if (XenosStringUtils.isBlank(optionType)){
			            	results.push(new ValidationResult(true, 
			                    "optionType", "nooptionType", "Option Type is Mandatory for InstrumentType ["+ parentInstrumentType + "]"));
						}
						if (XenosStringUtils.isBlank(strikePriceStr)){
			            	results.push(new ValidationResult(true, 
			                    "strikePriceStr", "nostrikePriceStr", "Strike Price is Mandatory for InstrumentType ["+ parentInstrumentType + "]"));
						}

						if (XenosStringUtils.isBlank(contractStartDateStr)){
			            	results.push(new ValidationResult(true, 
			                    "contractStartDateStr", "nocontractStartDateStr", "Contract Start Date is Mandatory for InstrumentType ["+ parentInstrumentType + "]"));
						}
						
						if (XenosStringUtils.isBlank(contractStartDateStr)){
			            	results.push(new ValidationResult(true, 
			                    "contractExpiryDateStr", "nocontractExpiryDateStr", "Contract Expiry Date is Mandatory for InstrumentType ["+ parentInstrumentType + "]"));
						}
			
            			
            			
            		}*/
            		
            		
              		
            		
            	}
            	catch(e:Error)
            	{
            		trace(e);
            	}
            }
            
    		
 			
 			
 			/*if(underlyingInstrumentCode != ""){
	 			   var numVal1:Number = Number(underlyingInstrumentCode);
					if (isNaN(numVal1)) {
						results.push(new ValidationResult(true, 
	                    	"underlyingInstrumentCode", "underlyingInstrumentCodeStr", "Underlying Instrument is invalid."));
					}
			}*/

        	 //check contractStartDateStr is valid or not
        	if(contractStartDateStr != ""){
	            validDate1 = DateUtils.isValidDate(contractStartDateStr) ;            
	            if(!validDate1) {
	                results.push(new ValidationResult(true, 
	                    "contractStartDateStr", "illegalcontractStartDateStr", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.contractstartdate')+" " + contractStartDateStr));
	               
	            }
        		
        	 }
        	 
        	  //check contractExpiryDateStr is valid or not
        	if(contractExpiryDateStr != ""){
	            validDate2 = DateUtils.isValidDate(contractExpiryDateStr) ;            
	            if(!validDate2) {
	                results.push(new ValidationResult(true, 
	                    "contractExpiryDateStr", "illegalcontractExpiryDateStr", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.contractexpirydate')+" " + contractExpiryDateStr));
	               
	            }
        		
        	 }
        	 
        	 // check receiveDateFromStr and receiveDateToStr range is valid or not
        	if(contractStartDateStr != "" && contractExpiryDateStr != "" && validDate1 && validDate2){
        		compareResult = DateUtils.compareDates (contractStartDateStr, contractExpiryDateStr);
        		if(compareResult != -1){
        			 results.push(new ValidationResult(true, 
	                    "contractStartDateStr", "invalidcontractStartDateStr", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.contractdaterange')));
        		}
        	}
			
			
                      												
			
			return results;
        }
		
	}
	
	
}