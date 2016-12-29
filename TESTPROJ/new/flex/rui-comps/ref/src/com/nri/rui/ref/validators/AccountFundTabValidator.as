package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class AccountFundTabValidator extends Validator
	{
		public var results:Array=[];
		
		public function AccountFundTabValidator()
		{
			super();
		}

        protected override function doValidation(value:Object):Array {        	
           
            var fundCodeStr:String = "";
            var fundNameStr:String = "";
            var officeIdStr:String = "";
            var fundCategoryStr:String = "";
            var baseCurrencyStr:String = "";
            var lmPositionCustodyStr:String = "";
            var taxFeeInclusionStr:String = "";
            var iconRequiredStr:String = "";
            var cashViewerRequiredStr:String = "";
            var fbpifRequiredStr:String = "";
            var gemsRequiredStr:String = "";
            //var int1RequiredStr:String = "";
            //var rtfpRequiredStr:String = "";
            var formaRequiredStr:String = "";
            var instructionCopyRcvBicStr:String = "";
            var copyInstructionTypeStr:String = "";
           
            var startDateStr:String = "";
            var closeDateStr:String = "";
            var validDate1:Boolean = false;
 			var validDate2:Boolean = false;
 			var compareResult:Number = 1;
            
            if (value != null) {
            	
            	try
            	{
            		fundCodeStr = StringUtil.trim(value['fundCode']);
	            	fundNameStr = StringUtil.trim(value['fundName']);
	            	officeIdStr = StringUtil.trim(value['officeId']);
	            	fundCategoryStr = StringUtil.trim(value['fundCategory']);
	            	baseCurrencyStr = StringUtil.trim(value['baseCurrency']);
	            	lmPositionCustodyStr = StringUtil.trim(value['lmPositionCustody']);
	            	taxFeeInclusionStr = StringUtil.trim(value['taxFeeInclusion']);
	            	iconRequiredStr = StringUtil.trim(value['iconRequired']);
	            	gemsRequiredStr = StringUtil.trim(value['gemsRequired']);
	            	//int1RequiredStr = StringUtil.trim(value['int1Required']);
	            	//rtfpRequiredStr = StringUtil.trim(value['rtfpRequired']);
	            	formaRequiredStr = StringUtil.trim(value['formaRequired']);
	            	cashViewerRequiredStr = StringUtil.trim(value['cashViewerRequired']);
	            	fbpifRequiredStr = StringUtil.trim(value['fbpifRequired']);
	            	instructionCopyRcvBicStr = StringUtil.trim(value['instructionCopyRcvBic']);
	            	copyInstructionTypeStr = StringUtil.trim(value['copyInstructionType']);
	            	startDateStr = StringUtil.trim(value['startDateStr']);
	            	closeDateStr = StringUtil.trim(value['closeDateStr']);
            	}
            	catch(e:Error)
            	{
            		trace(e);
            	}
            }
            
            if (XenosStringUtils.isBlank(fundCodeStr)) {
            	results.push(new ValidationResult(true, 
                    "fundCode", "fundCode", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.fundcode')));
			}
			            
            if (XenosStringUtils.isBlank(fundNameStr)){
            	results.push(new ValidationResult(true, 
                    "fundName", "fundName", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.fundname')));
			}
			
            if (XenosStringUtils.isBlank(officeIdStr)){
            	results.push(new ValidationResult(true, 
                    "officeId", "officeId", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.officeid')));
			}
			
			if (XenosStringUtils.isBlank(fundCategoryStr)){
            	results.push(new ValidationResult(true, 
                    "fundCategory", "fundCategory", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.fundcatagory')));
			}
			
            if (XenosStringUtils.isBlank(baseCurrencyStr)){
            	results.push(new ValidationResult(true, 
                    "baseCurrency", "baseCurrency", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.basecurrencey')));
			} 
			
            if (XenosStringUtils.isBlank(lmPositionCustodyStr)){
            	results.push(new ValidationResult(true, 
                    "lmPositionCustody", "lmPositionCustody", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.lmpositioncustody')));
			}
			
            if (XenosStringUtils.isBlank(taxFeeInclusionStr)){
            	results.push(new ValidationResult(true, 
                    "taxFeeInclusion", "taxFeeInclusion", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.taxfee')));
			}	
			
			if (XenosStringUtils.isBlank(iconRequiredStr)){
            	results.push(new ValidationResult(true, 
                    "iconRequired", "iconRequired", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.icon')));
			}	
			
			if (XenosStringUtils.isBlank(cashViewerRequiredStr)){
            	results.push(new ValidationResult(true, 
                    "cashViewerRequired", "cashViewerRequired", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.cashviewer')));
			}
			
			if (XenosStringUtils.isBlank(fbpifRequiredStr)){
            	results.push(new ValidationResult(true, 
                    "fbpifRequired", "fbpifRequired", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.fbpif')));
			}
			
			if (XenosStringUtils.isBlank(gemsRequiredStr)){
            	results.push(new ValidationResult(true, 
                    "gemsRequired", "gemsRequired", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.gems')));
			}
			/*
            if (XenosStringUtils.isBlank(int1RequiredStr)){
            	results.push(new ValidationResult(true, 
                    "int1Required", "int1Required", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.int')));
			}
			
            if (XenosStringUtils.isBlank(rtfpRequiredStr)){
            	results.push(new ValidationResult(true, 
                    "rtfpRequired", "rtfpRequired", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.rtfp')));
			}
			*/
			if (XenosStringUtils.isBlank(formaRequiredStr)){
            	results.push(new ValidationResult(true, 
                    "formaRequired", "formaRequired", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.forma')));
			}
			if ( !XenosStringUtils.isBlank(instructionCopyRcvBicStr) ){
				if( instructionCopyRcvBicStr.length!= 11 ){
					results.push(new ValidationResult(true, 
                    "formaRequired", "formaRequired", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.receivebic')));
				}
				if( XenosStringUtils.isBlank(copyInstructionTypeStr) ){
					results.push(new ValidationResult(true, 
                    "formaRequired", "formaRequired", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.copyinstructiontype')));
				}
			}else{
				if( !XenosStringUtils.isBlank(copyInstructionTypeStr) ){
					results.push(new ValidationResult(true, 
                    "formaRequired", "formaRequired", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.receivebiccopy')));
				}
			}
			
			//check start date is valid or not
        	if(startDateStr != ""){
	            validDate1 = DateUtils.isValidDate(startDateStr) ;            
	            if(!validDate1) {
	                results.push(new ValidationResult(true, 
	                    "startDateStr", "illegalstartDateStr", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.illegalstartdate')+" " + startDateStr));
	               
	            }
        		
        	 }
        	 
        	 //check close date is valid or not
        	if(closeDateStr != ""){
	             validDate2 = DateUtils.isValidDate(closeDateStr);           
	            if(!validDate2) {
	                results.push(new ValidationResult(true, 
	                    "closeDateStr", "illegalcloseDateStr", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.illegaclosedate')+" " + closeDateStr));
	               
	            }
        		
        	 }
        	
        	// check baseDateFromStr and baseDateToStr range is valid or not
        	if(startDateStr != "" && closeDateStr != "" && validDate1 && validDate2){
        		compareResult = DateUtils.compareDates (startDateStr, closeDateStr);
        		if(compareResult == 1){
        			 results.push(new ValidationResult(true, 
	                    "startDateStr", "invalidstartDateStr",Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.fundtab.invalidstartclose')));
        		}
        	}												
			
			return results;
        }
		
	}
}