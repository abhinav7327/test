package com.nri.rui.ref.validators
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
	
	public class AccountDocumentActionEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;
	
		public function AccountDocumentActionEntryValidator()
		{
			super();
		}
		
		/**
         * 
         * validate document action query form
         */ 
       
        protected override function doValidation(value:Object):Array {
        	
        	
        	
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
        	//XenosAlert.info("Length="+String(StringUtil.trim(value.salesRole)).length);
        	
      	  if((XenosStringUtils.isBlank(value.actionId))) {
        		results.push(new ValidationResult(true,"", "actionId", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.documententry.actionid')));
	           
        	}
        	
         if(XenosStringUtils.isBlank(value.documentActionDate)){
         	results.push(new ValidationResult(true,"", "documentActionDate", Application.application.xResourceManager.getKeyValue('ref.account.alert.validator.documententry.agreementaction')));
         }
          if(value.documentActionDate != ""){
	          /*  var dateformat:CustomDateFormatter =new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString="YYYYMMDD";
	            var formatData:String ="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.documentActionDate));
	            */
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.documentActionDate))) {
	                
	                results.push(new ValidationResult(true, 
	                    "documentActionDate", "illegalDcumentActionDate", Application.application.xResourceManager.getKeyValue('ref.comp.alert.validator.dateformat')+" " + value.documentActionDate));
	                //return results;
	            }
        		
        	}
        	
        	 /* if((value.salesRole is Object) || String(StringUtil.trim(value.salesRole)).length == 15) {
        		results.push(new ValidationResult(true,"", "salesId", "Sales Id Cannot Be Blank."));
	            return results;
        	}*/
        	
        	
                    	
        	
        	return results;
        }

	}
}