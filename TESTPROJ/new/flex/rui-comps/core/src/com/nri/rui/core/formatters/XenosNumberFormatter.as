
package com.nri.rui.core.formatters
{
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.formatters.NumberFormatter;

	public class XenosNumberFormatter extends NumberFormatter
	{
		public function XenosNumberFormatter()
		{
			super();
		}
		// Overriding the format function of the base class NumberFormatter
        // Converting the  'M','T','B' in respective numeric values
        override public function format(value:Object):String {
            if(value == null || value.toString().length ==0){
                error = defaultInvalidValueError;
                return "";            
            }
            value = getNumericValue(value);
          	var counter:int=0;
            var numArrTemp:Array = value.split(".");
       		var numFraction:String = numArrTemp[0]
       		var leadingZeroIndx:int=0;
       		//for extra leading zero
       		if(numArrTemp.length>1){
	            for (counter = 0; counter < numFraction.length; counter++){
	            	if (numFraction.charAt(counter)!="0"){
	            		break;
	            	}
	            	leadingZeroIndx +=1; 
	            }
         	}
            var leadingZero :String =numFraction.substring(0,leadingZeroIndx);
            value = super.format(value);
            if(leadingZero!=null){
            	value = leadingZero+value;
            }
            return String(value);
            
        }
        /**
     * Get numeric value of the given field.
     */
      private function getNumericValue(value:Object):String {   
        // Reset any previous errors.
        if (error)
            error = null;      	       
        value = value.toString().replace(/\,/g,"");   
        var number:String = String(value);
        if(number.length == 0) {
            error = defaultInvalidValueError;
            return "";
        }
        number = number.toUpperCase();    
        
        var isValidAmt:Boolean = checkValidNumber(number);
        if(isValidAmt == false ) {
          //Alert.show("Invalid Input Specified");
           error = defaultInvalidFormatError;
           return "";
        }    
     
        var posOfB:int = -1;
           
        posOfB = number.indexOf("B");
        var posOfM:int = -1;
        posOfM = number.indexOf("M");
        var posOfT:int = -1;
        posOfT = number.indexOf("T");
    
        var countBMT:int = 0;
        if(posOfB >= 0)
            countBMT ++;
        if(posOfM >= 0)
            countBMT ++;
        if(posOfT >= 0)
            countBMT ++;
        // At most one of B, M or T could exist
        if(countBMT > 1) {
           error = defaultInvalidFormatError;
           return "";
        }
            
    
        // Format Billion
        if(posOfB >= 0)
        {
            var validNumberB:String = getValidNumber(number, posOfB);
            if(validNumberB == null){ 
            	error = defaultInvalidFormatError;           
                return null;
            }
            number = (Number(validNumberB) * 1000000000).toString();        
        }
        else if(posOfM >= 0)
        {
            var validNumberM:String = getValidNumber(number, posOfM);
            if(validNumberM  == null) {
            	error = defaultInvalidFormatError;
                return null;
            }
            number = (Number(validNumberM) * 1000000).toString();
        }
        else if(posOfT >= 0)
        {
            var validNumberT:String = getValidNumber(number, posOfT);
            if(validNumberT == null) {
            	error = defaultInvalidFormatError;
                return null;
            }
            number = (Number(validNumberT) * 1000).toString();
        } else {
            number = getValidNumber(number, number.length);      
        }  
        trace("Valid number :: " + number);
        return number;
        
       }
       /**
        * Check whether the number is valid or not and return the numeric portion.
        */
        private function getValidNumber(number:String, pos:int):String  {
           var strBeforeBMT:String = number.substr(0, pos);
           var strAfterBMT:String = number.substr(pos+1, number.length-1);
           if((strBeforeBMT == null || strBeforeBMT.length == 0) 
              ||  (strAfterBMT != null && strAfterBMT.length > 0)) {
              	error = defaultInvalidValueError;
           	    return null;
           }
                
        
           return strBeforeBMT;
       }
       
       /**
       * Checking valid input
       */
       private function checkValidNumber(number:String):Boolean {
           var length:int = number.length;
           var i:int = 0;
           if(number.charAt(0) != '.' &&  number.charAt(0) != '-' && isNaN(Number(number.charAt(0))) ){            
               return false;             
           }
           while(i<length){
               if(isNaN(Number(number.charAt(i))) && (number.charAt(i) != '.')&&  (number.charAt(0) != '-')) {          
                   if(!((i == length -1) && ((number.charAt(i) == 'B')|| 
                       (number.charAt(i) == 'M') ||(number.charAt(i) == 'T')))) {
                       return false;
                   }    
               }
               i++;
           }
           return true;
      } 
       
	}
}