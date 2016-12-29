package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class AccountCustodianValidator extends Validator
	{
		public var results:Array=[];
		public static var CP_INTERNAL:String="INTERNAL";
		public static var CP_BANKCUST:String="BANK/CUSTODIAN";
		public static var CP_BROKER:String="BROKER";
		
		public function AccountCustodianValidator()
		{
			super();
		}

        protected override function doValidation(reqObj:Object):Array {    
           var cpDetailType:String="";    	
           var acShortName:String="";
           var offName1:String="";
          
           var fundCode:String="";
           var brokerCode:String="";
           
            if (reqObj != null) {
            	
            	try
            	{
            		cpDetailType=StringUtil.trim(reqObj['cpDetailType']);
            		acShortName=StringUtil.trim(reqObj['bankAccount.shortName']);	
            		offName1=StringUtil.trim(reqObj['bankAccount.officialName1']);
            		brokerCode=StringUtil.trim(reqObj['bankAccount.brokerCode']);
            	}
            	catch(e:Error)
            	{
            		trace(e);
            	}
            }
            
           
            
            if (XenosStringUtils.isBlank(acShortName)) {
            	results.push(new ValidationResult(true, 
                    "acShortName", "acShortName", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.custodian.shortname')));
			}			            
          	if (XenosStringUtils.isBlank(offName1)) {
            	results.push(new ValidationResult(true, 
                    "offName1", "offName1", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.custodian.officialname')));
			}
						
			if (XenosStringUtils.isBlank(brokerCode)) {
            		results.push(new ValidationResult(true, 
                    "brokerCode", "brokerCode", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.custodian.fininstcode')));
			} 
			 
			return results;
        }
		
	}
}