
package com.nri.rui.fam.utils
{
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.controls.XenosErrors;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.NumberUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.collections.ArrayCollection;
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
	    
    public class DateUtils
    {
        public function DateUtils()
        {
        }

        /**
         * This method will validate a String supplied for being a Date.
         * It validates for the String to be in YYYYMMDD format also.
         */
        public static function isValidDate(dateStr:String):Boolean {
        	var year:Number = parseInt(dateStr.substr(0,4));
			var month:Number = parseInt(dateStr.substr(4,2));
            if(XenosStringUtils.isBlank(dateStr)) {
                return false;
            }
            else if(dateStr.length > 6){
                return false;                
            }
            else if(!XenosStringUtils.isBlank(StringUtil.trim(dateStr)) && NumberUtils.checkValidNumber(dateStr) && dateStr.length < 6){
                return false;                 
            }
            else if(!XenosStringUtils.isBlank(StringUtil.trim(dateStr)) && NumberUtils.checkValidNumber(dateStr) && !(month>0 && month <13)) {
				return false;  
            }
			else if(!XenosStringUtils.isBlank(StringUtil.trim(dateStr)) && NumberUtils.checkValidNumber(dateStr) && !(year>0)) {
				return false;  
            }           
             //The Date is valid
             return true;                
        }
       		
    }
}