package com.nri.rui.adp.validator
{
	import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
	
	public class SegregateBalanceEntryQueryValidator extends Validator
	{
		public var results:Array=[];
		
		public function SegregateBalanceEntryQueryValidator()
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
            
            var securityCode:String = StringUtil.trim(queryModel.securityCode);
            var fundCode:String = StringUtil.trim(queryModel.fundCode);
            
            if(securityCode == ""){
            	results.push(new ValidationResult(true,"securityCode", "securityCodeMissing", Application.application.xResourceManager.getKeyValue('adp.segregatebalance.validator.entry.securityCodeMissing')));
            }
            return results;			
		}
	}
}