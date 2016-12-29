
 
package com.nri.rui.core.utils
{
    /**
     * Utility Class.
     * 
     */ 
    public class NumberUtils
    {
        /**
         * Checking valid input
         */
        public static function checkValidNumber(number:String):Boolean {
            var length:int = number.length;
            var i:int = 0;
            if(isNaN(Number(number.charAt(0)))){      
                return false;         
            }
            while(i<length){
                if(isNaN(Number(number.charAt(i))) && (number.charAt(i) != '.')) {      
                    return false;
                }
                i++;
            }
            return true;
        }
        
        /**
         * Checking string as valid number(negative value allowed)
         */
        public static function checkValidNegativeNumber(number:String):Boolean {
            var length:int = number.length;
            var i:int = 0;
            
        	if((number.charAt(0) != '-') && isNaN(Number(number.charAt(0)))){
                return false;         
            }else{
            	i++;
            }
            
            while(i<length){
                if(isNaN(Number(number.charAt(i))) && (number.charAt(i) != '.')) {      
                    return false;
                }
                i++;
            }
            return true;
        }
       
    }
}