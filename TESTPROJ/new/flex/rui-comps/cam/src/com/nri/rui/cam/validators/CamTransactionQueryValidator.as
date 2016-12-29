// ActionScript file

  
package com.nri.rui.cam.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    
    
    
    /**
     * Custom Validator for Cam Transaction Query Implementation.
     * 
     */    
    public class CamTransactionQueryValidator extends Validator
    {
    	 // Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function CamTransactionQueryValidator()
        {
            super();
        }
        
        /**
         * 
         * validate cam transaction query form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
        	
        	if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('cam.label.object.null'));
                return null;
            }
            
            var accNo:String = value.accNo;
            var securityCode:String = value.security;
            //var currency:String = value.currency;
            var fromDate:String = value.transDateFrom;
            var toDate:String = value.transDateTo;
            var fund:String = value.fundCode;
            //var flag:int=0;
        	
        	
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;
            //return null;
            
            //Check Fund Code field. 
            if (XenosStringUtils.isBlank(fund)) {
                results.push(new ValidationResult(true, 
                    "fund", "nofund", Application.application.xResourceManager.getKeyValue('cam.label.enter.fund.code')));
                //return results;
            }
            // Check account number  field. 
            /*
            if (XenosStringUtils.isBlank(accNo)) {
                results.push(new ValidationResult(true, 
                    "accNo", "noaccNo", "Please enter Account Number."));
                //return results;
            }
            */
            
            // Check toDate and fromDate  field.           
            if (XenosStringUtils.isBlank(toDate) || XenosStringUtils.isBlank(fromDate)) {
                results.push(new ValidationResult(true, 
                    "", "notoandfromDate", Application.application.xResourceManager.getKeyValue('cam.label.enter.both.from.to.date')));
               // return results;
            }
            /*
            if(XenosStringUtils.isBlank(securityCode))
            {
                results.push(new ValidationResult(true,"","securityCodeRequird","Please enter Security Code."));
                return results;                
            }
            */
            // Check to & Form Date Format . 
            var fromDateObj:Date = null;
            var toDateObj:Date=null;
            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            if(!XenosStringUtils.isBlank(fromDate)){
            if(DateUtils.isValidDate(fromDate)){
                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(fromDate));
            }else{
                results.push(new ValidationResult(true, 
                            "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('cam.label.invalid.from.date'))); 
            }
            }
           if(!XenosStringUtils.isBlank(fromDate)){
            if(DateUtils.isValidDate(toDate)){
                toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(toDate));
            }else{
                results.push(new ValidationResult(true, 
                            "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('cam.label.invalid.to.date'))); 
            }
           }
            // Return if there are errors for the fromDate or toDate.
            if (results.length > 0)
                return results;
            
            var comDate:int=ObjectUtil.dateCompare(fromDateObj,toDateObj);
            // check Form Date not less than To Date
            if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", Application.application.xResourceManager.getKeyValue('cam.label.from.date.less.to.date')));
            }
                        
            //Security and Currency cannot be entered together                    
            /*if(!XenosStringUtils.isBlank(securityCode) && !XenosStringUtils.isBlank(currency))
            {
                results.push(new ValidationResult(true,"","securityCodeandcurrencyBothNotRequird","Security and Currency cannot be entered together"));    
                flag = 1;
            }*/
            
            
            return results;
        }
    }
}