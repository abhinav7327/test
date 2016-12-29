/*
 *
 *
 *$Author: sutanuc $
*/



package com.nri.rui.core.logging
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.controls.XenosHTTPService;
	
	import mx.core.mx_internal;
	import mx.logging.ILogger;
	import mx.logging.LogEvent;
	import mx.logging.targets.LineFormattedTarget;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

    use namespace mx_internal;
    /**
     *  The Log target using Http Service
     */
	public class LogHttpServiceTarget extends LineFormattedTarget
	{
		[Bindable]
        public var logRequest : XenosHTTPService;
        // The constructor 
		public function LogHttpServiceTarget()
		{
			super();
			
			this.includeDate = true;
			this.includeTime = true;
			this.includeLevel = true;
			this.includeCategory = true;
			this.fieldSeparator = " ";
			
			this.logRequest = new XenosHTTPService();
			logRequest.addEventListener("result", writeLogInformation);
            logRequest.addEventListener("fault", showAlertMessage);   
            logRequest.showBusyCursor=false;
            logRequest.useProxy=false;
            this.logRequest.method="POST";
		}
		
		
   /**
     * Paddint the time with Zero
     * @num The number like hour, minutes, seconds
     * @millis The milliseconds will be included default false
     */
    public function padTime(num:Number, millis:Boolean = false):String
    {
        if (millis)
        {
            if (num < 10)
                return "00" + num.toString();
            else if (num < 100)
                return "0" + num.toString();
            else 
                return num.toString();
        }
        else
        {
            return num > 9 ? num.toString() : "0" + num.toString();
        }
    }
		
   /**
     *  This method handles a <code>LogEvent</code> from an associated logger.
     *  A target uses this method to translate the event into the appropriate
     *  format for transmission, storage, or display.
     *  This method is called only if the event's level is in range of the
     *  target's level.
     * 
     *  @param event The <code>LogEvent</code> handled by this method.
     */
    override public function logEvent(event:LogEvent):void
    {
	    
        var date:String = ""
        if (includeDate || includeTime)
        {
            var d:Date = new Date();
            if (includeDate)
            {
                date = Number(d.getMonth() + 1).toString() + "/" +
                       d.getDate().toString() + "/" + 
                       d.getFullYear() + fieldSeparator;
            }   
            if (includeTime)
            {
                date += padTime(d.getHours()) + ":" +
                        padTime(d.getMinutes()) + ":" +
                        padTime(d.getSeconds()) + "." +
                        padTime(d.getMilliseconds(), true);
            }
        }
        
        var level:String = "";
        if (includeLevel)
        {
            level = LogEvent.getLevelString(event.level);
        }

        var category:String = includeCategory ?
                              ILogger(event.target).category + fieldSeparator :
                              "";
        var finalMessage : String = " [ " + date + " ]-[ " + level + " ]-[ " + category + " ]--> " + event.message;
        internalLog(finalMessage);
    }
	    /**
	     *  @private
	     *  This method outputs the specified message directly to the method
	     *  specified (passed to the constructor) for the local connection.
	     *
	     *  @param message String containing preprocessed log message which may
	     *  include time, date, category, etc. based on property settings,
	     *  such as <code>includeDate</code>, <code>includeCategory</code>, etc.
	     */
	    override mx_internal function internalLog(message:String):void
	    {
	       var rndNo:Number= Math.random();
	       var currentTime:Date = new Date();
	       // gets the time values
           var seconds:uint = currentTime.getSeconds();
           var minutes:uint = currentTime.getMinutes();
           var hours:uint = currentTime.getHours();

	       
	       var args:Object = new Object();
               args.logMsg = message;
               args.logLevel = LogEvent.getLevelString(level);
	           args.rnd = Math.random() + "";
	           
	       logRequest.request = args;
	       
	       logRequest.url="ref/clientLogDispatchAction.action?"+ "method=writeLog&unique=" + new Date().getSeconds() + "&rnd=" + rndNo;  

	       logRequest.send();
	    }
	    /**
	     * The Result event handler 
	     */
	    public function writeLogInformation(event: ResultEvent) : void{
	    	//no ops
            //XenosAlert.info("log information has been written successfully");
        }
        /**
         * Fault Event handler 
         */
        public function showAlertMessage(event: FaultEvent) : void{
        	//no ops
            //XenosAlert.error("Fail to write the log information");
        }
	}
}