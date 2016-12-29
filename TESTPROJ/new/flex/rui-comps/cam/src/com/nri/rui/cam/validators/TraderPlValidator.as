
 
package com.nri.rui.cam.validators
{
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.core.controls.XenosAlert;
    
    import mx.core.Application;
    import mx.validators.Validator;
    import mx.validators.ValidationResult;

    /**
     * Custom Validator for Cam trader Pl Query Implementation.
     * 
     */    
    public class TraderPlValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function TraderPlValidator()
        {            
            super();
        }
        
        /**
         * 
         * validate trader Pl query form
         */       
        protected override function doValidation(value:Object):Array
        {
           if(value == null)
           {
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('cam.label.object.null'));
                return null;
           }
           
           var balanceType:String = value.balanceType;
           var accountNo:String = value.accountNo;
           var securityId:String = value.securityId;
           
           // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            // Check balanceType  field. 
            if (XenosStringUtils.isBlank(balanceType)) {
                results.push(new ValidationResult(true, 
                    "balType", "balanceType", Application.application.xResourceManager.getKeyValue('cam.label.select.balance.type')));
                return results;
            }
            // Check accountNo and securityId field. 
            /*if(XenosStringUtils.isBlank(accountNo) && XenosStringUtils.isBlank(securityId))
            {
                results.push(new ValidationResult(true, 
                    "nullAccSec", "nullAccSec", "Account No or Security Id is Mandatory"));
                return results;
            }*/
            return results;             
        }
    }
}