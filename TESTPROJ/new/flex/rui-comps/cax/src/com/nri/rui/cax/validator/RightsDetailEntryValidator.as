package com.nri.rui.cax.validator
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    
    
	public class RightsDetailEntryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
		
		public function RightsDetailEntryValidator()
		{
			super();
		}
		/**
         * 
         * validate ncm adjustment entry form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
            if(value == null){
                XenosAlert.info("value object is null");
                return null;
            }
                     
            
            var accNo:String = value.accountNo;            
            //var accBalanceType:String = value.accBalanceType;
            //var form:String = value.form;
            var secBalance:String = value.secBalance;
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;
            
/*             // Check fund Code  field. 
            if (XenosStringUtils.isBlank(accBalanceType)) {
                results.push(new ValidationResult(true, 
                    "accBalanceType", "noaccBalanceType", "Please enter Account Balance Type."));
            }  
              */
            // Check account number  field. 
            if (XenosStringUtils.isBlank(accNo)) {
                results.push(new ValidationResult(true, 
                    "accNo", "noaccNo", Application.application.xResourceManager.getKeyValue('cax.empty.account.no')));
            }  
/*             // Check currency  field. 
            if (XenosStringUtils.isBlank(form)) {
                results.push(new ValidationResult(true, 
                    "form", "noform", "Please enter Form."));
            } */ 
            // Check amount  field. 
            if (XenosStringUtils.isBlank(secBalance)) {
                results.push(new ValidationResult(true, 
                    "secBalance", "nosecBalance", Application.application.xResourceManager.getKeyValue('cax.empty.sec.balance')));
            }           
             
            if(results.length > 0 ){ 
                return results;    
            }            
            
            
            return results;    
            
        }

	}
}