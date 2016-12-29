package com.nri.rui.swp.validator
{
	import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;

	public class TradeDeliverEntryValidator extends Validator
	{
		public var results:Array=[];
		
		public function TradeDeliverEntryValidator()
		{
			super();
		}
		
		protected override function doValidation(reqObj:Object):Array
        {
        	var dateformat:CustomDateFormatter = new CustomDateFormatter();
            
            results = super.doValidation(reqObj);
            
            if (results.length > 0)
            {
                return results;             
            }
            
            return results;
        }
		
	}
}