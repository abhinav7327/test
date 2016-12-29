// ActionScript file

  
package com.nri.rui.fam.validators
{
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.fam.formatters.CustomDateFormatter;
    import com.nri.rui.fam.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    
    
    
    /**
     * Custom Validator for Cam Transaction Query Implementation.
     * 
     */    
    public class FamCloseEntryDeleteValidator extends Validator
    {
    	 // Define Array for the return value of doValidation().
        private var results:Array;
		private static const ILLEGAL_CLOSING_MONTH: String = "illegalClosingMonth";
				//A property for screen label against which user input is obtained
		private static const LABEL: String = "LABEL";
		//A property for user input obtained through screen
		private static const VALUE: String = "VALUE";
        // constructor
        public function FamCloseEntryDeleteValidator()
        {
            super();
        }
        
        /**
         * 
         * validate cam transaction query form
         */ 
       
        protected override function doValidation(value:Object):Array
        {
        	
        	if(value == null){
                XenosAlert.info(Application.application.xResourceManager.getKeyValue('fam.label.object.null'));
                return null;
            }
            var closingDate:String = value.transClosingDate;
            results = [];
            
            // Call base class's doValidation().
            results = super.doValidation(value);
                    
            // Return if there are errors.
            if (results.length > 0)
                return results;
            //return null;
            
            // Check Closing  Date Format . 
            var closingDateObj:Date = null;
                       
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            var valueDateList:Array=[];
            if (!XenosStringUtils.isBlank(closingDate))
			{
				valueDateList.push(getLabelInputObject(closingDate, "Closing Month"));
			}
			for (var i:int=0; i < valueDateList.length; i++)
			{
			    var obj:Object = valueDateList[i];
				var input:String = obj[VALUE];
				var label:String = obj[LABEL];	
	            if(!XenosStringUtils.isBlank(closingDate)) {
		            if(!DateUtils.isValidDate(closingDate)) {
		            	results.push(new ValidationResult(true, "Closing Month", ILLEGAL_CLOSING_MONTH, Application.application.xResourceManager.getKeyValue('fam.label.invalid.closing.month', new Array([label],[input]))));
		            }
	            } 
			}
           
            // Return if there are errors for the fromDate or toDate.
            if (results.length > 0)
                return results;
            
            return results;
        }
        // Returns an object with two String properties 1) LABEL, 2) VALUE
	private function getLabelInputObject(labelStr:String, inputStr:String):Object{
	        var obj:Object = new Object();
			obj[LABEL]= labelStr ;
			obj[VALUE]= inputStr;
			return obj;
	}
    }
}