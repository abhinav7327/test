package com.nri.rui.ref.validators
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class CPStandingQueryvalidator extends Validator
	{
		 private var results:Array;
		public function CPStandingQueryvalidator()
		{
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
 		
 					
 			//check Sort fields        
	                      
	         var sortField1:String = value.sortField1;
             var sortField2:String = value.sortField2;
             var sortField3:String = value.sortField3;
   
   
    	if((sortField1!=" " && sortField1==sortField2) || 
           (sortField2!=" " && sortField2==sortField3) || 
           (sortField3!=" " && sortField3==sortField1))
            {
              results.push(new ValidationResult(true, 
	                    "sortField1","sortField2", Application.application.xResourceManager.getKeyValue('ref.cpstanding.alert.validator.query.sortfielddifferent')));
   		    }
   		    
   		   if (value.counterPartyType!="" && value.counterPartyCode=="" ){
   		   	 results.push(new ValidationResult(true, 
	                    "counterPartyType","counterPartyType",Application.application.xResourceManager.getKeyValue('ref.cpstanding.alert.validator.query.validcounterparty')));
   		   	
   		   }
   		   
   	     if (value.accountNo!="" && value.localAccountNo!="" ){
   		   	 results.push(new ValidationResult(true, 
	                    "accountNo","localAccountNo",Application.application.xResourceManager.getKeyValue('ref.cpstanding.alert.validator.query.cporlocal')));
   		   	
   		   }
               	
        	
        	return results;
        }
		
	}
}