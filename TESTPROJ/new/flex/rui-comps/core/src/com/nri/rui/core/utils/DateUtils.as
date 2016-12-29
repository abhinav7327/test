
package com.nri.rui.core.utils
{
    import com.nri.rui.core.controls.XenosErrors;
	import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.core.utils.NumberUtils;
    import mx.utils.StringUtil;
    import mx.utils.ObjectUtil;
	import mx.formatters.DateFormatter;
	import com.nri.rui.core.startup.XenosApplication;
	import com.nri.rui.core.Globals;
	import mx.collections.ArrayCollection;
	    
    public class DateUtils
    {
        public function DateUtils()
        {
        }
        /**
         * This method will convert a String to a Date.
         * It accepts the String to be in YYYYMMDD format
         */
        public static function toDate(dateStr : String):Date {
            if(XenosStringUtils.isBlank(dateStr))
                return null;
            var year : Number = new Number(dateStr.substr(0,4));
            var month : Number = new Number(dateStr.substr(4,2)) - 1;
            var day : Number = new Number(dateStr.substr(6,2));
            
            return new Date(year,month,day);
                
        }
        /**
         * This method will validate a String supplied for being a Date.
         * It validates for the String to be in YYYYMMDD format also.
         */
        public static function isValidDate(dateStr:String):Boolean {
            if(XenosStringUtils.isBlank(dateStr))
                return false;
            
             // Check to & Form Date Format.            
            var dateformat:CustomDateFormatter =new CustomDateFormatter();
            //format of the date
            dateformat.formatString="YYYYMMDD";
                        
            if(dateStr.length > 8){
                return false;                
            }else if(!XenosStringUtils.isBlank(StringUtil.trim(dateStr)) && NumberUtils.checkValidNumber(dateStr)){
                    dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateStr));
                    if(dateformat.error != null){
                        return false;
                    }                    
             }else{            
                    return false;
             }
             //The Date is valid
             return true;                
        }
        /**
         * This method accept two date in string format(YYYYMMDD) and convert then to timestamp to compare
         * returning -1 if the first date is before the second, 
         * 0 if the dates are equal, 
         * or 1 if the first date is after the second
         *  
         */
         
         public static function compareDates (dateStr1 : String, dateStr2 : String) : Number
		{
		    var date1:Date = DateUtils.toDate(dateStr1);
		    var date2:Date = DateUtils.toDate(dateStr2);
		    var result : Number = -1;
		    
		    result = ObjectUtil.dateCompare(date1, date2) ;
		    
		  /*  var date1Timestamp : Number = date1.getTime ();
		    var date2Timestamp : Number = date2.getTime ();
		
		    var result : Number = -1;
		
		    if (date1Timestamp == date2Timestamp)
		    {
		        result = 0;
		    }
		    else if (date1Timestamp > date2Timestamp)
		    {
		        result = 1;
		    }*/
		    return result;
		} 
		
        public static function validateBaseDate(errPage:XenosErrors, moduleName:String, dateLabel:String, dateValue:String):Boolean
		{
			// Remove errors
			errPage.removeError();
			
			var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
			var matches:XMLList = app.cachedItems.retentionDates.date.(@component == moduleName);
			trace("matches : " + matches.toXMLString());
			if (matches == null || matches.length() == 0) {
				return true;
			}		
			var retentionDate:String = matches[0].@value;
			trace("retentionDate : " + retentionDate);

			var errors:ArrayCollection = new ArrayCollection();
			trace("dateLabel: " + dateLabel);
			trace("dateValue: " + dateValue);
			
			var year:Number = parseInt(dateValue.substring(0, 4));
			var month:Number = parseInt(dateValue.substring(4, 6)) - 1;
			var date:Number = parseInt(dateValue.substring(6, 8));
			trace("new Date(year, month, date): " + new Date(year, month, date));

			if (new Date(year, month, date).getTime() < new Date(retentionDate).getTime()) {
			
				var formatter:DateFormatter = new DateFormatter();
				formatter.formatString = "YYYYMMDD";
				var retentionDateStr:String = formatter.format(retentionDate);
				var msg:String = dateLabel + " is less than Retention Start Date - [" + retentionDateStr + "].";
				errors.addItem(msg);
			}
				
			if (errors.length > 0) {
				errPage.showError(errors);
				return false;
			}
			return true;
		} 		
    }
}