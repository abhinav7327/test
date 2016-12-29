
package com.nri.rui.nam.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.NumberUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    import mx.core.Application;
    
    /**
     * Custom Validator for Nam Feed Execute Implementation.
     * 
     */    
    public class NamFeedExecuteValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;
        
        public function NamFeedExecuteValidator()
        {
            super();
        }
        
        /**
         * 
         * validate Nam Feed Execute entry form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
            if(value == null){
                XenosAlert.info("value object is null");
                return null;
            }
            
            var offId:String = value.officeId;
            var intTyp:String = value.intfType;
            var intTypVal:String = "";
            var issueCcy:String = value.issueCcy;
            
            if(!XenosStringUtils.isBlank(intTyp))
            {
            	intTypVal = value.intfTypeVal;
            }
            //XenosAlert.info("Amount :"+amt);
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;
            
            // Check office field. 
            if (XenosStringUtils.isBlank(offId)) {
                results.push(new ValidationResult(true, 
                    "offId", "nooffId", Application.application.xResourceManager.getKeyValue('nam.prompt.enter.office.offId')));
            }  
            // Check interfaceType  field. 
            if (XenosStringUtils.isBlank(intTyp)) {
                results.push(new ValidationResult(true, 
                    "", "intTyp", Application.application.xResourceManager.getKeyValue('nam.prompt.enter.intf.type')));
            } 
            // Check Issue Currency  field.
            if (XenosStringUtils.isBlank(issueCcy) && !XenosStringUtils.isBlank(offId) && XenosStringUtils.equals(offId, 'TK')
            && XenosStringUtils.equals(intTypVal, 'INTFTXNPX001')) {
                results.push(new ValidationResult(true, 
                    "", "issueCcy", Application.application.xResourceManager.getKeyValue('nam.prompt.enter.issueccy.type')));
            }

            if(results.length > 0 ){ 
                return results;    
            }
            
            return results;    
            
        }
     }       
}