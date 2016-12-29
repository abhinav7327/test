package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class AccountGeneralValidator extends Validator
	{
		public var results:Array=[];
		public static var CP_INTERNAL:String="INTERNAL";
		public static var CP_BANKCUST:String="BANK/CUSTODIAN";
		public static var CP_BROKER:String="BROKER";
		public static var SHORT_POSITION:String="S";
		public function AccountGeneralValidator()
		{
			super();
		}

        protected override function doValidation(reqObj:Object):Array {    
           var cpDetailType:String="";    	
           var acShortName:String="";
           var offName1:String="";
           var serviceOffice:String=""
           var fundCode:String="";
           var brokerCode:String="";
           var longShortFlag:String ="";
           var primeBrokerAccounNo = "";
            if (reqObj != null) {
            	
            	try
            	{
            		cpDetailType=StringUtil.trim(reqObj['cpDetailType']);
            		acShortName=StringUtil.trim(reqObj['account.shortName']);	
            		offName1=StringUtil.trim(reqObj['account.officialName1']);
            		serviceOffice=StringUtil.trim(reqObj['otherAttributes.serviceOffice']);
            		fundCode=StringUtil.trim(reqObj['account.fundCode']);
            		brokerCode=StringUtil.trim(reqObj['account.brokerCode']);
            		longShortFlag = StringUtil.trim(reqObj['account.longShortFlag']);
            		primeBrokerAccounNo = StringUtil.trim(reqObj['account.primeBrokerAccountNo']);
            		
            	}
            	catch(e:Error)
            	{
            		trace(e);
            	}
            }
            
           
            
            if (XenosStringUtils.isBlank(acShortName)) {
            	results.push(new ValidationResult(true, 
                    "acShortName", "acShortName", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.general.shortname')));
			}			            
          	if (XenosStringUtils.isBlank(offName1)) {
            	results.push(new ValidationResult(true, 
                    "offName1", "offName1", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.general.officialname')));
			}
			
			if(cpDetailType != CP_BANKCUST) {
				if (XenosStringUtils.isBlank(serviceOffice)) {
	            	results.push(new ValidationResult(true, 
	                    "serviceOffice", "serviceOffice", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.general.serviceoffice')));
				}   
			}
			
			if(cpDetailType==CP_INTERNAL || cpDetailType==CP_BANKCUST){
				if (XenosStringUtils.isBlank(fundCode)) {
            		results.push(new ValidationResult(true, 
                    "fundCode", "fundCode", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.general.fundcode')));
				}  
			} 
			
			if(cpDetailType==CP_INTERNAL){
				if (!XenosStringUtils.isBlank(brokerCode)) {
            		results.push(new ValidationResult(true, 
                    "brokerCode", "brokerCode", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.general.brokercodeforfund')));
				} 
				if (XenosStringUtils.isBlank(longShortFlag)) {
            		results.push(new ValidationResult(true, 
                    "longShortFlag", "longShortFlag", "For FUND Account, Long/Short Flag cannot be empty"));
				} 
				if(XenosStringUtils.equals(longShortFlag , SHORT_POSITION)) {
					if (XenosStringUtils.isBlank(primeBrokerAccounNo)) {
	            		results.push(new ValidationResult(true, 
	                    "primeBrokerAccounNo", "primeBrokerAccounNo", Application.application.xResourceManager.getKeyValue('ref.account.alert.missing.primebroker.longShortFlag')));
					} 
				}
			}
			
			if(cpDetailType==CP_BROKER){
				if (XenosStringUtils.isBlank(brokerCode)) {
            		results.push(new ValidationResult(true, 
                    "brokerCode", "brokerCode", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.general.brokercode')));
				} 
			}
			 
			if(cpDetailType==CP_BANKCUST){
				if (XenosStringUtils.isBlank(brokerCode)) {
            		results.push(new ValidationResult(true, 
                    "brokerCode", "brokerCode", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.general.fininstcode')));
				} 
			}
			
			 
			return results;
        }
		
	}
}