package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class AccountContractValidator extends Validator
	{
		private var results:Array;
		
		public function AccountContractValidator()
		{
			super();
		}

        protected override function doValidation(value:Object):Array {
        	
            results = [];
       
            var stateStr:String = "";
			var pattern_a:RegExp = /^[A-Za-z0-9]+$/;
            
            if (value != null) {
            	
            	try
            	{
            		
            		
            		stateStr = StringUtil.trim(value['stateStr']);
              		
            		
              		
            		
            	}
            	catch(e:Error)
            	{
            		trace(e);
            	}
            }
            
   
        	 //check stateStr is valid or not
        	if(stateStr != ""){
	           
	           	if(pattern_a.test(stateStr) == false)
				results.push(new ValidationResult(true, "StateStr", "illegalStateStr", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.contract.state')));

        	 }
     												
			
			return results;
        }
		
	}
	
	
}