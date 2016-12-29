package com.nri.rui.stl.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	public class InxReportQueryValidators extends Validator
	{
		private var results:Array;
		public function InxReportQueryValidators() 
		{
			super();
		}
		/**
         * 
         * validate Completion summary form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
			if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('stl.message.error.objectnull'));
                return null;
            }
                     
            var trxDate:String = value.trxDate;
            var inxCreateDate:String = value.inxCreateDate;
                        
            // Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            var fromDateObj:Date = null;          
            if(trxDate!=""){
	            if(DateUtils.isValidDate(trxDate)){	           
	                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(trxDate));
	            }else{	            
	                results.push(new ValidationResult(true, 
	                            "trxDate", "invalidtrxDate", Application.application.xResourceManager.getKeyValue('stl.message.error.invalidtrdtrxdate'))); 
	            }
	         }
	         
	         if(inxCreateDate!=""){
	            if(DateUtils.isValidDate(inxCreateDate)){
	                fromDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(inxCreateDate));
	            }else{
	                results.push(new ValidationResult(true, 
	                            "inxCreateDate", "invalidinxCreateDate", Application.application.xResourceManager.getKeyValue('stl.message.error.invalidtrdinxcreateddate'))); 
	            }
	         }            
            return results;
        }

	}
}