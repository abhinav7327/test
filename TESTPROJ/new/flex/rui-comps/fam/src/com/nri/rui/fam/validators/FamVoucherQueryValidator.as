// ActionScript file


 
package com.nri.rui.fam.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	import com.nri.rui.fam.FamConstants;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
    
    /**
     * Custom Validator for Voucher Query Implementation
     * 
     */   
	public class FamVoucherQueryValidator extends Validator {
		
		// Define Array for the return value of doValidation()
        private var results:Array;

        // Constructor
        public function FamVoucherQueryValidator() {
            super();
        }
               
        /**
         * 
         * Validate Voucher Query form
         */ 
        protected override function doValidation(value:Object):Array {
        	
            if (value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('fam.error.validation.object.null'));
                return null;
            }
            
            var fundCodeArrColl:ArrayCollection=value.fundCodeArrCollValidate; 
            var multipleFundSelector:Boolean = value.multipleFundSelector;
            var voucherType:String=value.voucherType;           
            var bookDateFrom:String=value.bookDateFrom; 
            var bookDateTo:String=value.bookDateTo; 
            var exDateFrom:String=value.exDateFrom; 
        	var exDateTo:String =value.exDateTo;
        	var paymentDateFrom:String =value.paymentDateFrom;
        	var paymentDateTo:String =value.paymentDateTo;
        	var security:String =value.security;
        	
        	var flag:int=0;
            
            // Clear results Array.
            results = [];

            // Call base class's doValidation()
            results = super.doValidation(value);
            
            // Return if there are errors
            if (results.length > 0)
                return results; 
                
            if(fundCodeArrColl.length==0 && multipleFundSelector == false){
            	results.push(new ValidationResult(true, 
					"fundCodes", "emptyFundCode", Application.application.xResourceManager.getKeyValue('fam.voucherquery.label.empty.fund.code', null)));
            }              
            // Check Book Date From field
            if (!XenosStringUtils.isBlank(bookDateFrom) && !DateUtils.isValidDate(StringUtil.trim(bookDateFrom))) {
				results.push(new ValidationResult(true, 
					"bookDateFrom", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.bookdatefrom', new Array([bookDateFrom]))));
            }
            
            // Check Book Date To field
            if (!XenosStringUtils.isBlank(bookDateTo) && !DateUtils.isValidDate(StringUtil.trim(bookDateTo))) {
				results.push(new ValidationResult(true, 
					"bookDateTo", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.bookdateto', new Array([bookDateTo]))));
            }
            
            // Check Ex Date From field
            if (!XenosStringUtils.isBlank(exDateFrom) && !DateUtils.isValidDate(StringUtil.trim(exDateFrom))) {
				results.push(new ValidationResult(true, 
					"exDateFrom", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.exdatefrom', new Array([exDateFrom]))));
            }
            
            // Check Ex Date To field
            if (!XenosStringUtils.isBlank(exDateTo) && !DateUtils.isValidDate(StringUtil.trim(exDateTo))) {
				results.push(new ValidationResult(true, 
					"exDateTo", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.exdateto', new Array([exDateTo]))));
            }
            
            // Check Payment Date From field
            if (!XenosStringUtils.isBlank(paymentDateFrom) && !DateUtils.isValidDate(StringUtil.trim(paymentDateFrom))) {
				results.push(new ValidationResult(true, 
					"paymentDateFrom", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.paymentdatefrom', new Array([paymentDateFrom]))));
            }
            
            // Check Payment Date To field
            if (!XenosStringUtils.isBlank(paymentDateTo) && !DateUtils.isValidDate(StringUtil.trim(paymentDateTo))) {
				results.push(new ValidationResult(true, 
					"paymentDateTo", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.paymentdateto', new Array([paymentDateTo]))));
            }
            
            // Check whether Book Date From is less than or equal to Book Date To
            if (!XenosStringUtils.isBlank(bookDateFrom) && DateUtils.isValidDate(StringUtil.trim(bookDateFrom))
	            	&& !XenosStringUtils.isBlank(bookDateTo) && DateUtils.isValidDate(StringUtil.trim(bookDateTo))) {
				
				if (DateUtils.compareDates(bookDateFrom, bookDateTo) == 1) {
					results.push(new ValidationResult(true, 
						XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", 
						Application.application.xResourceManager.getKeyValue('fam.label.error.bookdatefrom.lessthan.booddateto', new Array([bookDateFrom],[bookDateTo]))));
				}
            }
            
            // Check whether Ex Date From is less than or equal to Ex Date To
            if (!XenosStringUtils.isBlank(exDateFrom) && DateUtils.isValidDate(StringUtil.trim(exDateFrom))
	            	&& !XenosStringUtils.isBlank(exDateTo) && DateUtils.isValidDate(StringUtil.trim(exDateTo))) {
	            		
				if (DateUtils.compareDates(exDateFrom, exDateTo) == 1) {
					results.push(new ValidationResult(true, 
						XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", 
						Application.application.xResourceManager.getKeyValue('fam.label.error.exdatefrom.lessthan.exdateto', new Array([exDateFrom],[exDateTo]))));
				}
            }
            
            // Check whether Payment Date From is less than or equal to Payment Date To
            if (!XenosStringUtils.isBlank(paymentDateFrom) && DateUtils.isValidDate(StringUtil.trim(paymentDateFrom))
	            	&& !XenosStringUtils.isBlank(paymentDateTo) && DateUtils.isValidDate(StringUtil.trim(paymentDateTo))) {
	            		
				if (DateUtils.compareDates(paymentDateFrom, paymentDateTo) == 1) {
					results.push(new ValidationResult(true, 
						XenosStringUtils.EMPTY_STR, "fromDateLessThantoDate", 
						Application.application.xResourceManager.getKeyValue('fam.label.error.paymentdatefrom.lessthan.paymentdateto', new Array([paymentDateFrom],[paymentDateTo]))));
				}
            }
          
           // Check Ex Date is for only "Receivable Dividend Income Adjust"
            if ((!XenosStringUtils.isBlank(exDateFrom) || !XenosStringUtils.isBlank(exDateTo)) && !XenosStringUtils.equals(voucherType, FamConstants.RECEIVABLE_DIV_INCOME_ADJUST)) {
	           		
				results.push(new ValidationResult(true, 
					"exDate", "noExDate", Application.application.xResourceManager.getKeyValue('fam.label.error.exdate.onlyfor.specific.vourchettype')));
				
            }
            
             // Check Payment Date is for only "Receivable Dividend Income Adjust"
            if ((!XenosStringUtils.isBlank(paymentDateFrom)|| !XenosStringUtils.isBlank(paymentDateTo)) && !XenosStringUtils.equals(voucherType, FamConstants.RECEIVABLE_DIV_INCOME_ADJUST)) {
	           		
				results.push(new ValidationResult(true, 
					"paymentDate", "noPaymentDate", Application.application.xResourceManager.getKeyValue('fam.label.error.paymentdate.onlyfor.specific.vourchettype')));
				
            }
           
                       
            // Check Security Code is for  "Receivable Dividend Income Adjust","ACCRUED_INTEREST_ADJUST","ACCRUED_INTEREST_PAID_ADJUST"
            if (!XenosStringUtils.isBlank(security) &&
                    ( !(XenosStringUtils.equals(voucherType, FamConstants.RECEIVABLE_DIV_INCOME_ADJUST) 
                    || XenosStringUtils.equals(voucherType, FamConstants.ACCRUED_INTEREST_ADJUST)
                    || XenosStringUtils.equals(voucherType, FamConstants.ACCRUED_INTEREST_PAID_ADJUST)))) {
	           		
				results.push(new ValidationResult(true, 
					"securityCode", "noSecurityCode", Application.application.xResourceManager.getKeyValue('fam.label.error.security.onlyfor.specific.vourchettype')));
				
            }
            
            
             
        	return results;
        } 
	}
}
