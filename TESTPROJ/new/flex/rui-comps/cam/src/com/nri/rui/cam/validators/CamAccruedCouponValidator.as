
  
package com.nri.rui.cam.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    import mx.utils.StringUtil;
    
    /**
     * Custom Validator for Cam Movement Query Implementation.
     * 
     */    
    public class CamAccruedCouponValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function CamAccruedCouponValidator()
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
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('cam.label.object.null'));
                return null;
            }
            
            var baseDate:String =value.baseDate;
            var securityCode:String=value.securityCode;
            var accountNo:String=value.accNo;
           
           
            var flag:int=0;
        
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            
            // Check baseDate field.           
         /*   if (XenosStringUtils.isBlank(baseDate) ) {
                results.push(new ValidationResult(true, 
                    "", "nobaseDate", "Please enter base date."));
                return results;
            }
        */
             // Check base Date Format.            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            var baseDateObj:Date = null;
            if (XenosStringUtils.isBlank(baseDate) ) {
            	
            	// No mandatory validation
            }else{
              if(DateUtils.isValidDate(StringUtil.trim(baseDate))){
              	
                baseDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(baseDate));
              }else{
            	
                results.push(new ValidationResult(true, 
                            "baseDate", "invalidBaseDate", Application.application.xResourceManager.getKeyValue('cam.label.invalid.base.date'))); 
                
             }
            }
  
            // Return if there are errors for the baseDate.
            if (results.length > 0)
                return results;
                            
       
            
            
            /* for checking the integer value  of accountNo */
            /*
            if(!XenosStringUtils.isBlank(accountNo))
            {
                if(NumberUtils.checkValidNumber(accountNo))
                {
                    if(accountNo.length!=3)
                    {
                        results.push(new ValidationResult(true,"","notValidaccountFrom",
                                                          "Account From value must be 3 digit integer"));
                    }            
                }else{            
                        results.push(new ValidationResult(true,"","notValidaccountFrom",
                                                            " Account From value must be integer"));    
                }
            }*/
                       
 
            return results;        
        }        
    }
}