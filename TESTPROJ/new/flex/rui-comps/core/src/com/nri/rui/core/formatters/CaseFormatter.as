package com.nri.rui.core.formatters
{
	import mx.formatters.Formatter;

	public class CaseFormatter extends Formatter
	{
		// Declare the variable to hold the pattern string.
        public var myFormatString:String = "upper";

		public function CaseFormatter()
		{
			super();
		}
		// Override format().
        override public function format(value:Object):String {
            // 1. Validate value - must be a nonzero length string.
            if( value.length == 0)
                {   error="0 Length String";
                    return ""
                }

            // 2. If the value is valid, format the string.
            switch (myFormatString) {
                case "upper" :
                    var upperString:String = value.toUpperCase();
                    return upperString;
                    break;
                case "lower" :
                    var lowerString:String = value.toLowerCase();
                    return lowerString; 
                    break;
                default :   
                    //error="Invalid Format String";
                    return value.toString();
            }
        }
    
	}
}