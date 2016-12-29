package com.nri.rui.slr.validator
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;
	
	public class Sbr_BalanceQueryValidator extends Validator
	{
	 private var results:Array;
		public function Sbr_BalanceQueryValidator()
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
	                    "sortField1","sortField2", Application.application.xResourceManager.getKeyValue('borrow.label.alert.validator.query.sortfielddifferent')));
   		    }
   		    
   		   if (value.baseDate==""){
   		   	 results.push(new ValidationResult(true, 
	                    "baseDate","baseDate",Application.application.xResourceManager.getKeyValue('borrow.error.basedate.blank')));
   		   	
   		   }
   		   
   	     if (value.balancebasis==" "){
   		   	 results.push(new ValidationResult(true, 
	                    "balancebasis","balancebasis",Application.application.xResourceManager.getKeyValue('borrow.error.balancebasis.blank')));
   		   	
   		   }
               	
        	return results;
        }
		
	}
}

	
