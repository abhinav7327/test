// ActionScript file


package com.nri.rui.trd.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosStringUtils;

	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    
    /**
     * Custom Validator for Trade Transaction Query Implementation.
     * 
     */   
	public class TradeTxnQueryValidator extends Validator{
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function TradeTxnQueryValidator()
        {
            super();
        }
               
        /**
         * 
         * validate movement query form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
            if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('trd.txnvalue.obj.null'));
                return null;
            }
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
                
                if (value.hasOwnProperty("fundCode") && XenosStringUtils.isBlank(value.fundCode))
       				results.push(new ValidationResult(true, 
                    	"fundCode", "fundCodeMissing", Application.application.xResourceManager.getKeyValue('trd.tradetxndetailquery.error.fundcode'))); 
         
                return results;
           
        }
	}
}