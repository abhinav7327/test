package com.nri.rui.ref.validators
{
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	import mx.core.Application;

	public class InstrumentBondDetailValidator extends Validator
	{
		public var results:Array = [];
		
		public function InstrumentBondDetailValidator()
		{
			super();
		}

        protected override function doValidation(value:Object):Array {
        	
           // results = [];
       
           
            var bondType:String = "";
            var issuePrice:String = "";
	        var redmpnCcy:String = "";
	        var redmpnPrice:String = "";
	        var issueDate:String = "";
	        var maturityDate:String = "";
	        var delayDays:String = "";
	        var pdFlag:String = "";
	        var tipsFlag:String = "";
	        var tipsBase:String = "";
	        var stripType:String = "";
	        var recordDays:String = "";

            var validDate1:Boolean = false;
 			var validDate2:Boolean = false;
 			var compareResult:Number = 1;
            
            if (value != null) {
            	
            	try
            	{
            		
            		bondType = StringUtil.trim(value['bondType']);
            		issueDate = StringUtil.trim(value['issueDate']);
              		maturityDate = StringUtil.trim(value['maturityDate']);

            		
            	}
            	catch(e:Error)
            	{
            		trace(e);
            	}
            }
            
    		

        	 //check issue date is valid or not
        	if(issueDate != ""){
	            validDate1 = DateUtils.isValidDate(issueDate) ;            
	            if(!validDate1) {
	                results.push(new ValidationResult(true, 
	                    "issueDate", "illegalissueDate", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.instrumentbondissuedate')+" " + issueDate));
	               
	            }
        		
        	 }
        	 
        	  //check maturityDate is valid or not
        	if(maturityDate != ""){
	            validDate2 = DateUtils.isValidDate(maturityDate) ;            
	            if(!validDate2) {
	                results.push(new ValidationResult(true, 
	                    "maturityDate", "illegalmaturityDate", Application.application.xResourceManager.getKeyValue('ref.instrument.alert.validator.instrumentbondmaturitydate')+" " + maturityDate));
	               
	            }
        		
        	 }
        	 
        	
			
			
                      												
			
			return results;
        }
		
	}
	
	
}