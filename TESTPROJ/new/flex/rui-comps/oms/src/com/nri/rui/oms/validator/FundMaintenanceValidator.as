package com.nri.rui.oms.validator
{
	import com.nri.rui.core.utils.XenosStringUtils;
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	public class FundMaintenanceValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
		public function FundMaintenanceValidator()
		{
			super();
		}
		/**
         * 
         * validate Fund Maintenance Entry form
         */ 
       
        protected override function doValidation(value:Object):Array {
        	
        	// Clear results Array.
            results = [];
            var fundCode:String = "";
            var securityCode:String = "";
            var bsFlag:String = "";
            var roundFlag:String = "";
            if(value!=null){
            	try
	            	{
		            	fundCode=StringUtil.trim(value['fundCode']);
		            	securityCode = StringUtil.trim(value['securityCode']);
		            	bsFlag = StringUtil.trim(value['bsFlag']);
		            	roundFlag = StringUtil.trim(value['roundFlag']);
	            	}
	            	catch(e:Error){
	            		trace(e);
	            	}
            }
            if (XenosStringUtils.isBlank(fundCode)){
            	results.push(new ValidationResult(true, 
                    "fundCode", "nofundCode", Application.application.xResourceManager.getKeyValue('oms.fund.maintenance.validation.fundcode')));
			}
			if (XenosStringUtils.isBlank(securityCode)){
            	results.push(new ValidationResult(true, 
                    "securityCode", "nosecurityCode", Application.application.xResourceManager.getKeyValue('oms.fund.maintenance.validation.securitycode')));
			}
			if (XenosStringUtils.isBlank(bsFlag)){
            	results.push(new ValidationResult(true, 
                    "bsFlag", "nobsFlag", Application.application.xResourceManager.getKeyValue('oms.fund.maintenance.validation.buysellflag')));
			}
			if (XenosStringUtils.isBlank(roundFlag)){
            	results.push(new ValidationResult(true, 
                    "roundFlag", "noroundflag", Application.application.xResourceManager.getKeyValue('oms.fund.maintenance.validation.roundflag')));
			}
			return results;
        }

	}
}