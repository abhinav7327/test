
package com.nri.rui.core.utils
{
	import mx.utils.StringUtil;

	public class XenosStringUtils
	{
		/**
		* The EMPTY String "". 
		*/
		public static const EMPTY_STR:String = "";
		public function XenosStringUtils()
		{
			super();
		}
		
		
		/**
		 * Checks if a String is whitespace, empty ("") or null.
		 * 
		 * @param str - the String to check, may be null 
		 * @return true if the String is null, empty or whitespace
		 * 
		 */
		public static function isBlank(str:String):Boolean {
			
			if(str == null || StringUtil.trim(str) == EMPTY_STR) {
                return true;
            }
			return false;
		}		
		/**
         * Compares two Strings, returning true if they are equal.
         * @param str1 - the first String, may be null
         * @param str2 - the second String, may be null 
         * @return true if the Strings are equal, case sensitive, or both null
         */
        public static function equals(str1:String, str2:String):Boolean	{
        	if ( str1 == null )
        	   str1 = EMPTY_STR;
        	   
        	if ( str2 == null)
			    str2 = EMPTY_STR;
            str1 = StringUtil.trim(str1);
            str2 = StringUtil.trim(str2);
            if (str1 == str2) 
			    return true;        		
        	
            return false;
        }
        /**
        * Checks whether a string contains only numeric characters.
        * The string is trimmed for leading and trailing whitespaces
        * after which it is tested.
        */
        public static function isNumeric(str:String):Boolean{
        	if ( str == null )
        	   str = EMPTY_STR;
        	if(str.length ==0 ) return true;
        	str = StringUtil.trim(str); 
        	var regEx :RegExp = /[^0-9]+/  
        	
        	return !regEx.test(str);
        }
        /**
        * Checks whether a string contains only alpha-numeric characters.
        * The string is trimmed for leading and trailing whitespaces
        * after which it is tested.
        */
        public static function isAlphaNumeric(str:String):Boolean{
        	if ( str == null )
        	   str = EMPTY_STR;
        	if(str.length ==0 ) return true;
        	str = StringUtil.trim(str); 
        	var regEx :RegExp = /[^a-zA-Z0-9]+/  
        	
        	return !regEx.test(str);
        }
        
        /**
        * Capitalizes a string i.e. the first character in the string is
        * converted to upper case.
        */
        public static function capitalize(str:String):String {
        	return str.charAt(0).toUpperCase() + str.substr(1);
        }
        
        /**
        * Check is the String contains withing the givenString. If Contains then return true else return false
        */
        public static function contains(fullString:String,containChar:String):Boolean{
        	if(fullString!=null){
        		var indx:int=fullString.indexOf(containChar);
        		if(indx!=-1){
        			return true;
        		}
        	}
        	return false;
        }
	}
}