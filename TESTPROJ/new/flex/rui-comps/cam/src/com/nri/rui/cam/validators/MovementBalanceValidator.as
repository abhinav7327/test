
  
package com.nri.rui.cam.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.NumberUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    
    /**
     * Custom Validator for Cam Movement Query Implementation.
     * 
     */    
    public class MovementBalanceValidator extends Validator
    {
        // Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
        public function MovementBalanceValidator()
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
            var movementBasis:String =value.movBasis;
            var toDate:String =value.toDate;
            var fromDate:String =value.fromDate;
            //var securityCode:String=value.securityCode;
            //var currency:String=value.ccy;
            var accountNo:String=value.accNo;
            var accountNoTo:String=value.accNoTo;
            var accountNoFrom:String=value.accNoFrom;
            var instrumentType:String=value.instrumentType;
            var appUpdDate:String=value.appUpdDate;
            //var flag:int=0;
        
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;

            // Check movementBasis  field. 
            if (XenosStringUtils.isBlank(movementBasis)) {
                results.push(new ValidationResult(true, 
                    "movBasis", "nomovementBasis", Application.application.xResourceManager.getKeyValue('cam.label.select.movement.basis')));
                //return results;
            }
            // Check toDate and fromDate  field.           
            if (XenosStringUtils.isBlank(toDate) || XenosStringUtils.isBlank(fromDate)) {
                results.push(new ValidationResult(true, 
                    "", "notoandfromDate", Application.application.xResourceManager.getKeyValue('cam.label.enter.both.from.to.date')));
                return results;
            }
             // Check to & Form Date Format.            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            var fromDateObj:Date = null;
            
            if(DateUtils.isValidDate(fromDate)){
                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(fromDate));
            }else{
                results.push(new ValidationResult(true, 
                            "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('cam.label.invalid.from.date'))); 
            }
            
            
            var toDateObj:Date=null;
            if(DateUtils.isValidDate(toDate)){
                toDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(toDate));
            }else{
                results.push(new ValidationResult(true, 
                            "toDate", "invalidToDate", Application.application.xResourceManager.getKeyValue('cam.label.invalid.to.date'))); 
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
//            if(!XenosStringUtils.isBlank(securityCode) && !XenosStringUtils.isBlank(currency))
//            {
//                results.push(new ValidationResult(true,"","securityCodeandcurrencyBothNotRequird","Security and Currency cannot be entered together"));    
//                flag = 1;
//            }
            
            //Last Entry Date validation
            if(!XenosStringUtils.isBlank(appUpdDate)){
                if(!DateUtils.isValidDate(appUpdDate)){                
                    results.push(new ValidationResult(true, 
                            "appUpdDate", "invalidLastEntryDate", Application.application.xResourceManager.getKeyValue('cam.label.invalid.last.entry.date'))); 
                }
            }
            
            
            //Account no and Account Range cannot be entered together
            if(!XenosStringUtils.isBlank(accountNo) && !XenosStringUtils.isBlank(accountNoFrom) && !XenosStringUtils.isBlank(accountNoTo))
            {
                results.push(new ValidationResult(true,"","accountNoandaccountRangeBothNotRequird",
                                                  Application.application.xResourceManager.getKeyValue('cam.label.accountno.accountrange.no.together')));                
            }
            
            //Account From and Account To must be entered together
            if(((!XenosStringUtils.isBlank(accountNoFrom)) && XenosStringUtils.isBlank(accountNoTo))||(XenosStringUtils.isBlank(accountNoFrom) && (!XenosStringUtils.isBlank(accountNoTo))))
            {
                results.push(new ValidationResult(true,"","accountFromandToMustBeEnteredTogether",
                                                 Application.application.xResourceManager.getKeyValue('cam.label.accountfrom.to.together')));
            }
            
            /* for checking the integer value  of accountNoFrom and accountNoTo */
            if(!XenosStringUtils.isBlank(accountNoFrom))
            {
                if(NumberUtils.checkValidNumber(accountNoFrom))
                {
                    if(accountNoFrom.length!=3)
                    {
                        results.push(new ValidationResult(true,"","notValidaccountFrom",Application.application.xResourceManager.getKeyValue('cam.label.account.from.three.digit')));
                    }            
                }else{            
                        results.push(new ValidationResult(true,"","notValidaccountFrom",Application.application.xResourceManager.getKeyValue('cam.label.account.from.integer')));    
                }
            }
                       
            if(!XenosStringUtils.isBlank(accountNoTo))
            {           
                if(NumberUtils.checkValidNumber(accountNoTo))
                {
                    if(accountNoTo.length!=3)
                    {
                       results.push(new ValidationResult(true,"","notValidaccountTo",Application.application.xResourceManager.getKeyValue('cam.label.account.to.three.digit')));     
                    }            
                }else{
                    results.push(new ValidationResult(true,"","notValidaccountTo",Application.application.xResourceManager.getKeyValue('cam.label.account.to.integer')));    
                }   
            } 
            
            /* if(flag == 0) 
            {
                if(!isBlank(securityCode) && !isBlank(instrumentTyp) && isCurrency(instrumentType))
                {
                     results.push(new ValidationResult(true, 
                    "","notValidSecurity","Security doesnot belong to the selected Instrument Type"));    
                }
                if(!isBlank(currency) && !isBlank(instrumentTyp) && !isCurrency(instrumentType))
                {
                    results.push(new ValidationResult(true, 
                    "","notValidCurrency","Currency doesnot belong to the selected Instrument Type"));    
                }
            }*/
            return results;        
        }        
    }
}