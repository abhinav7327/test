// ActionScript file

  
package com.nri.rui.fam.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.fam.FamConstants;
    
    import mx.core.Application;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    /**
     * Custom Validator for Fam Voucher Entry Implementation.
     * 
     */
         
    public class FamVoucherEntryValidator extends Validator {
    	 // Define Array for the return value of doValidation()
        private var results:Array;

        // constructor
        public function FamVoucherEntryValidator() {
            super();
        }
        
        /**
         * 
         * validate fam voucher entry form
         */ 
       
        protected override function doValidation(value:Object):Array {	
        	if(value == null) {
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('fam.label.object.null'));
                return null;
            }
        	
        	// The following fields need to be validated
        	
        	var voucherType : String = value.voucherType;
        	var fundCode : String = value.fundCode;
        	var securityCode : String = value.securityCode;
        	var share : String = value.share;
        	var bookDate : String = value.bookDate;
        	var allotmentAmount : String = value.allotmentAmount;
        	var localCcy : String = value.localCcy;
        	var exDate : String = value.exDate;
        	var paymentDate : String = value.paymentDate;
        	var amountlc : String = value.amountlc;
        	var amountbc : String = value.amountbc;
        	var dateList : Array = [];
        	var amountList : Array = [];
        	
            // Clear results Array
            results = [];

            // Call base class's doValidation()
            results = super.doValidation(value);
                    
            // Return if there are errors
            if (results.length > 0)
                return results;
             
             var dateformat:CustomDateFormatter = new CustomDateFormatter();
			 
			 //format of the date
			 dateformat.formatString = "YYYYMMDD";
			 var formatData:String = XenosStringUtils.EMPTY_STR;
			 var dateObj:Array=[];
            
        	 // Check Voucher Type field 
             if (XenosStringUtils.isBlank(voucherType)) {
                results.push(new ValidationResult(true, 
                    "voucherType", "noVoucherType", Application.application.xResourceManager.getKeyValue('fam.label.error.vouchertype')));
             }
            
             if (XenosStringUtils.equals(voucherType, FamConstants.PAYABLE_MGMT_FEE)) {
	            // Check Fund Code field 
	            if (XenosStringUtils.isBlank(fundCode)) {
	                results.push(new ValidationResult(true, 
	                    "fund", "noFund", Application.application.xResourceManager.getKeyValue('fam.label.error.fundcode')));
	            }
	            
	            // Check Book Date field 
	            if (XenosStringUtils.isBlank(bookDate)) {
	                results.push(new ValidationResult(true, 
	                    "bookDate", "noBookDate", Application.application.xResourceManager.getKeyValue('fam.label.error.bookdate')));
	            } else {
					if (!DateUtils.isValidDate(StringUtil.trim(bookDate))) {
						results.push(new ValidationResult(true, 
							"bookDate", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.bookdate', new Array([bookDate]))));
					}	
	            }
	            
	            // Check Amount (BC) field 
	            if (XenosStringUtils.isBlank(amountbc)) {
	                results.push(new ValidationResult(true, 
	                    "amountbc", "noAmountbc", Application.application.xResourceManager.getKeyValue('fam.label.error.amountbc')));
	            }
	            
	            if (results.length > 0) {
                   return results;
                }
             }
            
             if (XenosStringUtils.equals(voucherType, FamConstants.ACCRUED_INTEREST_ADJUST)) {
            	// Check Fund Code field 
	            if (XenosStringUtils.isBlank(fundCode)) {
	                results.push(new ValidationResult(true, 
	                    "fund", "noFund", Application.application.xResourceManager.getKeyValue('fam.label.error.fundcode')));
	            }
	            
	            // Check Book Date field 
	            if (XenosStringUtils.isBlank(bookDate)) {
	                results.push(new ValidationResult(true, 
	                    "bookDate", "noBookDate", Application.application.xResourceManager.getKeyValue('fam.label.error.bookdate')));
	            } else {
	            	if (!DateUtils.isValidDate(StringUtil.trim(bookDate))) {
						results.push(new ValidationResult(true, 
							"bookDate", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.bookdate', new Array([bookDate]))));
					}	
	            }
	            
	            // Check Payment Date field
	            if (!XenosStringUtils.isBlank(paymentDate) && !DateUtils.isValidDate(StringUtil.trim(paymentDate))) {
					results.push(new ValidationResult(true, 
						"paymentDate", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.paymentdate', new Array([paymentDate]))));
	            }
	            
	            // Check Security Code field
	            if (XenosStringUtils.isBlank(securityCode)) {
	                results.push(new ValidationResult(true, 
	                    "securityCode", "noSecurityCode", Application.application.xResourceManager.getKeyValue('fam.label.error.securitycode')));
	            }
	            
	            // Check Amount (LC) field 
	            if (XenosStringUtils.isBlank(amountlc)) {
	                results.push(new ValidationResult(true, 
	                    "amountlc", "noAmountlc", Application.application.xResourceManager.getKeyValue('fam.label.error.amountlc')));
	            }
	            
	            // Check Amount (BC) field 
	            if (XenosStringUtils.isBlank(amountbc)) {
	                results.push(new ValidationResult(true, 
	                    "amountbc", "noAmountbc", Application.application.xResourceManager.getKeyValue('fam.label.error.amountbc')));
	            }
	            
	            // Check whether Amount (LC) and Amount (BC) have the same sign
	            validateAmountLcAndAmountBc(amountlc, amountbc);
	            
	            if (results.length > 0) {
                   return results;
                }
             }
            
             if (XenosStringUtils.equals(voucherType, FamConstants.RECEIVABLE_DIV_INCOME_ADJUST)) {
            	// Check Fund Code field 
	            if (XenosStringUtils.isBlank(fundCode)) {
	                results.push(new ValidationResult(true, 
	                    "fund", "noFund", Application.application.xResourceManager.getKeyValue('fam.label.error.fundcode')));
	            }
	            
	            // Check Allotment Amount field 
	            if (XenosStringUtils.isBlank(allotmentAmount)) {
	                results.push(new ValidationResult(true, 
	                    "allotmentAmount", "noAllotmentAmount", Application.application.xResourceManager.getKeyValue('fam.label.error.allotmentamount')));
	            }
	            
	            // Check Share field
	            if (XenosStringUtils.isBlank(share)) {
	                results.push(new ValidationResult(true, 
	                    "share", "noShare", Application.application.xResourceManager.getKeyValue('fam.label.error.share')));
	            }
	            
	            // Check Book Date field 
	            if (XenosStringUtils.isBlank(bookDate)) {
	                results.push(new ValidationResult(true, 
	                    "bookDate", "noBookDate", Application.application.xResourceManager.getKeyValue('fam.label.error.bookdate')));
	            } else {
	            	if (!DateUtils.isValidDate(StringUtil.trim(bookDate))) {
						results.push(new ValidationResult(true, 
							"bookDate", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.bookdate', new Array([bookDate]))));
					}	
	            }
	            
	            // Check Security Code field
	            if (XenosStringUtils.isBlank(securityCode)) {
	                results.push(new ValidationResult(true, 
	                    "securityCode", "noSecurityCode", Application.application.xResourceManager.getKeyValue('fam.label.error.securitycode')));
	            }
	            
	            // Check Ex Date field 
	            if (XenosStringUtils.isBlank(exDate)) {
	                results.push(new ValidationResult(true, 
	                    "exDate", "noExDate", Application.application.xResourceManager.getKeyValue('fam.label.error.exdate')));
	            } else {
	            	if (!DateUtils.isValidDate(StringUtil.trim(exDate))) {
						results.push(new ValidationResult(true, 
							"exDate", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.exdate', new Array([exDate]))));
					}
	            }
	            
	            // Check Payment Date field
	            if (!XenosStringUtils.isBlank(paymentDate) && !DateUtils.isValidDate(StringUtil.trim(paymentDate))) {
					results.push(new ValidationResult(true, 
						"paymentDate", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.paymentdate', new Array([paymentDate]))));
	            }
	            
	            if (!XenosStringUtils.isBlank(paymentDate) && DateUtils.isValidDate(StringUtil.trim(paymentDate))
	            	&& !XenosStringUtils.isBlank(exDate) && DateUtils.isValidDate(StringUtil.trim(exDate))) {
	            		
					// Check whether Payment Date is greater than or equal to Ex Date
					if (DateUtils.compareDates(paymentDate, exDate) == -1) {
						results.push(new ValidationResult(true, 
							XenosStringUtils.EMPTY_STR, "paymentDateLessThanExDate", 
							Application.application.xResourceManager.getKeyValue('fam.label.error.paymentdate.lessthan.exdate', new Array([paymentDate],[exDate]))));
					}
	            }
	            
	            // Check Amount (LC) field 
	            if (XenosStringUtils.isBlank(amountlc)) {
	                results.push(new ValidationResult(true, 
	                    "amountlc", "noAmountlc", Application.application.xResourceManager.getKeyValue('fam.label.error.amountlc')));
	            }
	            
	            // Check Amount (BC) field 
	            if (XenosStringUtils.isBlank(amountbc)) {
	                results.push(new ValidationResult(true, 
	                    "amountbc", "noAmountbc", Application.application.xResourceManager.getKeyValue('fam.label.error.amountbc')));
	            }
	            
	            // Check whether Amount (LC) and Amount (BC) have the same sign
	            validateAmountLcAndAmountBc(amountlc, amountbc);
	            
	            if (results.length > 0) {
                   return results;
                }
             }
            
             if (XenosStringUtils.equals(voucherType, FamConstants.OTHER_PAY_EXPENSE)) {
            	// Check Fund Code field 
	            if (XenosStringUtils.isBlank(fundCode)) {
	                results.push(new ValidationResult(true, 
	                    "fund", "noFund", Application.application.xResourceManager.getKeyValue('fam.label.error.fundcode')));
	            }
	            
	            // Check Local Currency Code field 
	            if (XenosStringUtils.isBlank(localCcy)) {
	                results.push(new ValidationResult(true, 
	                    "localCcy", "noLocalCcy", Application.application.xResourceManager.getKeyValue('fam.label.error.localccy')));
	            }
	            
	            // Check Book Date field 
	            if (XenosStringUtils.isBlank(bookDate)) {
	                results.push(new ValidationResult(true, 
	                    "bookDate", "noBookDate", Application.application.xResourceManager.getKeyValue('fam.label.error.bookdate')));
	            } else {
	            	if (!DateUtils.isValidDate(StringUtil.trim(bookDate))) {
						results.push(new ValidationResult(true, "bookDate", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.bookdate', new Array([bookDate]))));
					}	
	            }
	            
	            // Check Amount (LC) field 
	            if (XenosStringUtils.isBlank(amountlc)) {
	                results.push(new ValidationResult(true, 
	                    "amountlc", "noAmountlc", Application.application.xResourceManager.getKeyValue('fam.label.error.amountlc')));
	            }
	            
	            // Check Amount (BC) field 
	            if (XenosStringUtils.isBlank(amountbc)) {
	                results.push(new ValidationResult(true, 
	                    "amountbc", "noAmountbc", Application.application.xResourceManager.getKeyValue('fam.label.error.amountbc')));
	            }
	            
	            // Check whether Amount (LC) and Amount (BC) have the same sign
	            validateAmountLcAndAmountBc(amountlc, amountbc);
	            
	            if (results.length > 0) {
                   return results;
                }
             }
            
             if (XenosStringUtils.equals(voucherType, FamConstants.ACCRUED_INTEREST_PAID_ADJUST)) {
            	// Check Fund Code field 
	            if (XenosStringUtils.isBlank(fundCode)) {
	                results.push(new ValidationResult(true, 
	                    "fund", "noFund", Application.application.xResourceManager.getKeyValue('fam.label.error.fundcode')));
	            }
            	
            	// Check Book Date field 
	            if (XenosStringUtils.isBlank(bookDate)) {
	                results.push(new ValidationResult(true, 
	                    "bookDate", "noBookDate", Application.application.xResourceManager.getKeyValue('fam.label.error.bookdate')));
	            } else {
	            	if (!DateUtils.isValidDate(StringUtil.trim(bookDate))) {
						results.push(new ValidationResult(true, "bookDate", "invalidDate", Application.application.xResourceManager.getKeyValue('fam.label.error.invalid.bookdate', new Array([bookDate]))));
					}
	            }
	            
	            // Check Security Code field
	            if (XenosStringUtils.isBlank(securityCode)) {
	                results.push(new ValidationResult(true, 
	                    "securityCode", "noSecurityCode", Application.application.xResourceManager.getKeyValue('fam.label.error.securitycode')));
	            }
	            
	            // Check Amount (LC) field 
	            if (XenosStringUtils.isBlank(amountlc)) {
	                results.push(new ValidationResult(true, 
	                    "amountlc", "noAmountlc", Application.application.xResourceManager.getKeyValue('fam.label.error.amountlc')));
	            }
	            
	            // Check Amount (BC) field 
	            if (XenosStringUtils.isBlank(amountbc)) {
	                results.push(new ValidationResult(true, 
	                    "amountbc", "noAmountbc", Application.application.xResourceManager.getKeyValue('fam.label.error.amountbc')));
	            }
	            
	            // Check whether Amount (LC) and Amount (BC) have the same sign
	            validateAmountLcAndAmountBc(amountlc, amountbc);
	            
	            if (results.length > 0) {
                   return results;
                }
            }
            
            return results;
        }
        
        /**
         *  This method checks whether Amount (LC) and Amount (BC) have the same sign
         * 
         *  @param   Amount LC
         *  @param   Amount BC
         */ 
        private function validateAmountLcAndAmountBc(amountlc : String, amountbc : String):void {
        	
        	var commaPattern:RegExp = /,/g;
            var amtLcStr:String = amountlc.replace(commaPattern,XenosStringUtils.EMPTY_STR);
            var amtBcStr:String = amountbc.replace(commaPattern,XenosStringUtils.EMPTY_STR);
            
        	// Check whether Amount (LC) and Amount (BC) have the same sign
	        if (!XenosStringUtils.isBlank(amountlc) && !XenosStringUtils.isBlank(amountbc)) {
	        	
	        	var amtLc:Number = new Number(amtLcStr);
            	var amtBc:Number = new Number(amtBcStr);
            	
            	if ((amtLc == 0 && amtBc == 0)) {
            		results.push(new ValidationResult(true, 
	                   "amountlcAndAmountbcBothZero", "amountlcAndAmountbcEqualsZero", 
	                   Application.application.xResourceManager.getKeyValue('fam.label.error.amountlc.and.amountbc.equals.zero')));
            	}
	        	
	        	if ((amtLc > 0 && amtBc < 0) || (amtLc < 0 && amtBc >0)) {
	           		results.push(new ValidationResult(true, 
	                   "amountlcAndAmountbc", "amountlcAndAmountbcUnequalSign", 
	                   Application.application.xResourceManager.getKeyValue('fam.label.error.amountlc.amountbc.unequal.sign')));
	            }
	        }
        }
    }
}