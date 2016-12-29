
  
package com.nri.rui.ncm.validators
{
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.utils.ObjectUtil;
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;

    /**
     * Custom Validator for Ncm Cash Projection Query - Cash Projection Query Implementation.
     * 
     */    
    public class NcmCashProjectionSummaryQueryValidator extends Validator
    {
    	// Define Array for the return value of doValidation().
        private var results:Array;

        // Constructor
 	public function NcmCashProjectionSummaryQueryValidator() {
            super();
        }
        
        /**
          * Validate movement query form.
          */ 
       
        protected override function doValidation(value:Object):Array {
            if(value == null) {
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('ncm.prompt.object.null'));
                return null;
            }
            var fundCode:String = value.fundCode;
            var dateFrom:String = value.dateFrom;
            var dateTo:String = value.dateTo;
            var flag:int = 0;
        	var fromDateObj:Date = null;
        	var toDateObj:Date = null ;
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0) {
                return results;
            }
			
            // Base Date validation.
            if(XenosStringUtils.isBlank(dateFrom)) {
            	results.push(new ValidationResult(true, "", "noDateFrom", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.from.date')));
            } else {
                if(!DateUtils.isValidDate(dateFrom)) {                
                    results.push(new ValidationResult(true, "dateFrom", "invalidDateFrom", Application.application.xResourceManager.getKeyValue('ncm.prompt.invalid.date.from'))); 
                }else{
                	fromDateObj = DateUtils.toDate(dateFrom) ;
                }
	    }            
            if(XenosStringUtils.isBlank(dateTo)) {
            	results.push(new ValidationResult(true, "", "noDateTo", Application.application.xResourceManager.getKeyValue('ncm.prompt.enter.to.date')));
            } else {
                if(!DateUtils.isValidDate(dateTo)) {                
                    results.push(new ValidationResult(true, "dateTo", "invalidDateTo", Application.application.xResourceManager.getKeyValue('ncm.prompt.invalid.to.date'))); 
                }else{
                	toDateObj = DateUtils.toDate(dateTo);
                }
	    }     
	    
	    // Return if there are errors.
            if (results.length > 0) {
                return results;
            }
            
            var comDate:int=ObjectUtil.dateCompare(fromDateObj,toDateObj);
            // check Form Date not less than To Date
            if (comDate==1) {
                results.push(new ValidationResult(true, 
                     "", "fromDateLessThantoDate", "From Date should be less than To Date."));
            }
            
            // Return if there are errors.
            if (results.length > 0) {
                return results;
            }
            
            var dateDiff:int = toDateObj.getTime() - fromDateObj.getTime();
            
            if (dateDiff > 864000000){
            	
            	results.push(new ValidationResult(true, 
                     "", "dateDiffValue", "Date Range should not be greater than 10days"));
            }
                  
            return results;        
        }
    }
}
