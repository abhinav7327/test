package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.controls.DateField;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class InstrumentCodeValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        
		public function InstrumentCodeValidator()
		{
			super();
		}
		
		/**
         * 
         * validate Instrument code  Entry form
         */ 
       
        protected override function doValidation(value:Object):Array {
        	
        	// Clear results Array.
            results = [];
            var instrumentCodeType:String = "";
            var securityId:String = "";
            
            if(value!=null){
            	try
	            	{
		            	instrumentCodeType=StringUtil.trim(value['instrumentCodeType']);
		            	securityId = StringUtil.trim(value['securityId']);		            	
	            	}
	            	catch(e:Error){
	            		trace(e);
	            	}
            }
            if (XenosStringUtils.isBlank(instrumentCodeType)){
            	results.push(new ValidationResult(true, 
                    "instrumentCodeType", "noinstrumentCodeType", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.instrumentcodetype')));
			}
			if (XenosStringUtils.isBlank(securityId)){
            	results.push(new ValidationResult(true, 
                    "securityId", "nosecurityId", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.instrumentcode')));
			}
			
			return results;
        }
		
	}
}