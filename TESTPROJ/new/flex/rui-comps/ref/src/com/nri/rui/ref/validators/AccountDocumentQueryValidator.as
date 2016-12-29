// ActionScript file


package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
   
    
    /**
     * Custom Validator for Trade Query Implementation.
     * 
     */
	public class AccountDocumentQueryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function AccountDocumentQueryValidator() {
			super();
		}
		
		/**
         * 
         * validate movement query form
         */ 
       
        protected override function doValidation(value:Object):Array {

        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
 		
 			var validDate1:Boolean = false;
 			var validDate2:Boolean = false;
 			var compareResult:Number = 1;
 			
 			//check contractDateFromStr is valid or not
        	if(value.contractDateFromStr != ""){
	            validDate1 = DateUtils.isValidDate(StringUtil.trim(value.contractDateFromStr)) ;            
	            if(!validDate1) {
	                results.push(new ValidationResult(true, 
	                    "contractDateFromStr", "illegalContractDateFromStr", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.contractDateFromStr));
	               
	            }
        		
        	 }
        	 
        	 //check contractDateToStr is valid or not
        	if(value.contractDateToStr != ""){
	             validDate2 = DateUtils.isValidDate(StringUtil.trim(value.contractDateToStr));           
	            if(!validDate2) {
	                results.push(new ValidationResult(true, 
	                    "contractDateToStr", "illegalContractDateToStr", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+"Illegal date format " + value.contractDateToStr));
	               
	            }
        		
        	 }
        	
        	// check contractDateFromStr and contractDateToStr range is valid or not
        	if(value.contractDateFromStr != "" && value.contractDateToStr != "" && validDate1 && validDate2){
        		compareResult = DateUtils.compareDates (value.contractDateFromStr, value.contractDateToStr);
        		if(compareResult == 1){
        			 results.push(new ValidationResult(true, 
	                    "contractDateFromStr", "invalidContractDateFromStr", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.documentquery.invalidcontractdaterange')));
        		}
        	}
        	
        	validDate1 = false;
 			validDate2 = false;
 			//check receiveDateFromStr is valid or not
        	if(value.receiveDateFromStr != ""){
	            validDate1 = DateUtils.isValidDate(StringUtil.trim(value.receiveDateFromStr)) ;            
	            if(!validDate1) {
	                results.push(new ValidationResult(true, 
	                    "receiveDateFromStr", "illegalReceiveDateFromStr", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.receiveDateFromStr));
	               
	            }
        		
        	 }
        	 
        	 //check receiveDateToStr is valid or not
        	if(value.receiveDateToStr != ""){
	             validDate2 = DateUtils.isValidDate(StringUtil.trim(value.receiveDateToStr));           
	            if(!validDate2) {
	                results.push(new ValidationResult(true, 
	                    "receiveDateToStr", "illegalReceiveDateToStr", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.receiveDateToStr));
	               
	            }
        		
        	 }
        	
        	// check receiveDateFromStr and receiveDateToStr range is valid or not
        	if(value.receiveDateFromStr != "" && value.receiveDateToStr != "" && validDate1 && validDate2){
        		compareResult = DateUtils.compareDates (value.receiveDateFromStr, value.receiveDateToStr);
        		if(compareResult == 1){
        			 results.push(new ValidationResult(true, 
	                    "receiveDateFromStr", "invalidReceiveDateFromStr", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.documentquery.invalidreceiveddaterange')));
        		}
        	}
        	
        	validDate1 = false;
 			validDate2 = false;
 			//check expiryDateFromStr is valid or not
        	if(value.expiryDateFromStr != ""){
	            validDate1 = DateUtils.isValidDate(StringUtil.trim(value.expiryDateFromStr)) ;            
	            if(!validDate1) {
	                results.push(new ValidationResult(true, 
	                    "expiryDateFromStr", "illegalExpiryDateFromStr", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.expiryDateFromStr));
	               
	            }
        		
        	 }
        	 
        	 //check expiryDateToStr is valid or not
        	if(value.expiryDateToStr != ""){
	             validDate2 = DateUtils.isValidDate(StringUtil.trim(value.expiryDateToStr));           
	            if(!validDate2) {
	                results.push(new ValidationResult(true, 
	                    "expiryDateToStr", "illegalExpiryDateToStr", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.expiryDateToStr));
	               
	            }
        		
        	 }
        	
        	// check expiryDateFromStr and expiryDateToStr range is valid or not
        	if(value.expiryDateFromStr != "" && value.expiryDateToStr != "" && validDate1 && validDate2){
        		compareResult = DateUtils.compareDates (value.expiryDateFromStr, value.expiryDateToStr);
        		if(compareResult == 1){
        			 results.push(new ValidationResult(true, 
	                    "expiryDateFromStr", "invalidExpiryDateFromStr", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.documentquery.invalidexpirydate')));
        		}
        	}
        	
        	
      	 	/*  if((XenosStringUtils.isBlank(value.documentStatus))) {
        		results.push(new ValidationResult(true,"", "documentStatus", "Document Status Cannot Be Blank."));
	           
        	}
        	
        	
        	
        	 if((value.salesRole is Object) || String(StringUtil.trim(value.salesRole)).length == 15) {
        		results.push(new ValidationResult(true,"", "salesId", "Sales Id Cannot Be Blank."));
	            return results;
        	}*/
        	
        	
                    	
        	
        	return results;
        }
		
	}
}