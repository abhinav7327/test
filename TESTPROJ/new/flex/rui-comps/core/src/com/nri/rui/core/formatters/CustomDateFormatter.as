
 
package com.nri.rui.core.formatters
{
    import mx.formatters.DateFormatter; 
    import mx.controls.Alert;
    
    /**
     * Custom date Formatter
     * 
     */    
    public class CustomDateFormatter extends DateFormatter
    {   
        /**
         * convert a string into a date 
         * 
         */
        public function toDate(dateStr:Object):Date{
            var tempDate:Date = DateFormatter.parseDateString(String(dateStr)); 
            
            if(tempDate!= null){
            return tempDate;    
            }else{
                error="Date cannot parse dateStr="+dateStr;
                //Alert.show(error);
                return null;
            }
        }
        
            
        public static function customizedInputDateString (inputStr:String):String{
            var customizedInputStr:String;
            customizedInputStr=inputStr.substr(0,4)+"/"+inputStr.substr(4,2)+"/"+inputStr.substr(6,2);
            //tempParseDateString(customizedInputStr);
            return customizedInputStr;
        }
    }
}