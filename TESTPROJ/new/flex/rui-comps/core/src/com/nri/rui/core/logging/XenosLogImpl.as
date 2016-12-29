/*
 *
 *
 *$Author: sutanuc $
*/


package com.nri.rui.core.logging
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.controls.XenosHTTPService;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
    
	public class XenosLogImpl 
	{
		
   /**
     *  @private
     *  The sole instance of the XenosLogImpl.
     */
    private static var instance:XenosLogImpl;
    private var testTarget:String;
    private var testEvent:LogEvent;
    [Bindable]
    private var writeLog:XLogManager;
	[Bindable]
	private var testCategory:String;
	
	private var initLogHttpService :XenosHTTPService;
	
	
	    // The defult constructor
		public function XenosLogImpl()
		{
			testTarget = "HttpService";
            testCategory = "Xenos-NAM";
            //Initializeing init log http service
            
            initLogHttpService = new XenosHTTPService();
            initLogHttpService.addEventListener("result", initLog);
            initLogHttpService.addEventListener("fault", showError);   
            initLogHttpService.showBusyCursor=false;
            initLogHttpService.useProxy=false;
            
            // A log event to hold level and message.
            testEvent = new LogEvent();
            testEvent.level = LogEventLevel.DEBUG;
            
 			doInit();
            //create an instance of log manager
            writeLog = new XLogManager();
 
             
		}
        private function doInit() :void {
        	
        	var args:Object = new Object();
                args.method = "doInit";
	            args.rnd = Math.random() + "";

	       initLogHttpService.request = args;
	       initLogHttpService.url="ref/clientLogDispatchAction.action?"+ "unique=" + new Date().getSeconds();  
	       initLogHttpService.send();
        }		
		private function initLog(event: ResultEvent):void {
		 	
		 	var initLevel :String =  event.result.clientLogWriterActionForm.logSetUpLevel;
		 	//XenosAlert.info("Init Level " + initLevel);

		 	if (XenosStringUtils.equals(initLevel, "DEBUG")){
		 	    testEvent.level = LogEventLevel.DEBUG;	
		 	} else if (XenosStringUtils.equals(initLevel, "INFO")){
		 		testEvent.level = LogEventLevel.INFO;	
		 	} else if (XenosStringUtils.equals(initLevel, "WARN")){
		 		testEvent.level = LogEventLevel.WARN;	
		 	} else if (XenosStringUtils.equals(initLevel, "ERROR")){
		 		testEvent.level = LogEventLevel.ERROR;	
		 	} else if (XenosStringUtils.equals(initLevel, "FATAL")){
		 		testEvent.level = LogEventLevel.FATAL;	
		 	} else if (XenosStringUtils.equals(initLevel, "ALL")){
		 		testEvent.level = LogEventLevel.ALL;	
		 	}
            //XenosAlert.info("Level Set " + testEvent.level);
		}
		private function showError(event: FaultEvent) : void{
			
            XenosAlert.error("Fail to initialize the log");
            //testEvent = new LogEvent();
            testEvent.level = LogEventLevel.FATAL;
            
            
        }
	   /**
	     *  Logs the specified data using the <code>LogEvent.INFO</code> level.
	     *  <code>LogEventLevel.INFO</code> designates informational messages that 
	     *  highlight the progress of the application at coarse-grained level.
	     *  
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param params Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     */
		public function info(message:String, params : Array):void {
			
			if ((testEvent.level <= LogEventLevel.INFO) ? true : false)
				write(LogEventLevel.INFO,message,params);
			    
		}
	   /**
	     *  Logs the specified data using the <code>LogEventLevel.WARN</code> level.
	     *  <code>LogEventLevel.WARN</code> designates events that could be harmful 
	     *  to the application operation.
	     *      
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *  
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param params Aadditional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     * 
	     */
		public function warn(message:String, params : Array):void {
			
			if ((testEvent.level <= LogEventLevel.WARN) ? true : false)
				write(LogEventLevel.WARN,message,params);
			
		}
	   /**
	     *  Logs the specified data using the <code>LogEventLevel.FATAL</code> 
	     *  level.
	     *  <code>LogEventLevel.FATAL</code> designates events that are very 
	     *  harmful and will eventually lead to application failure
	     *
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param params Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     *
	     */
		public function fatal(message:String, params : Array):void {
			
			if ((testEvent.level <= LogEventLevel.FATAL) ? true : false)
				write(LogEventLevel.FATAL,message,params);
			
		}
	   /**
	     *  Logs the specified data using the <code>LogEventLevel.ERROR</code>
	     *  level.
	     *  <code>LogEventLevel.ERROR</code> designates error events
	     *  that might still allow the application to continue running.
	     *  
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param message The information to log.
	     *  This String can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param params Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     *
         */
		public function error(message:String, params : Array):void {
			
			if ((testEvent.level <= LogEventLevel.ERROR) ? true : false)
				write(LogEventLevel.ERROR,message,params);
			
		}
	   /**
	     *  Logs the specified data using the <code>LogEventLevel.DEBUG</code>
	     *  level.
	     *  <code>LogEventLevel.DEBUG</code> designates informational level
	     *  messages that are fine grained and most helpful when debugging
	     *  an application.
	     *  
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param message The information to log.
	     *  This string can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param params Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     *
	     */
		public function debug(message:String, params : Array):void {
			
			if ((testEvent.level <= LogEventLevel.DEBUG) ? true : false)
				write(LogEventLevel.DEBUG,message,params);
			
		}
		/**
	     * This is the actual internal API which will execute the http service if the log level permits.
	     *  
	     *  <p>The string specified for logging can contain braces with an index
	     *  indicating which additional parameter should be inserted
	     *  into the string before it is logged.
	     *  For example "the first additional parameter was {0} the second was {1}"
	     *  will be translated into "the first additional parameter was 10 the
	     *  second was 15" when called with 10 and 15 as parameters.</p>
	     *
	     *  @param message The information to log.
	     *  This string can contain special marker characters of the form {x},
	     *  where x is a zero based index that will be replaced with
	     *  the additional parameters found at that index if specified.
	     *
	     *  @param params Additional parameters that can be subsituted in the str
	     *  parameter at each "{<code>x</code>}" location, where <code>x</code>
	     *  is an integer (zero based) index value into the Array of values
	     *  specified.
	     *
	     *
	     */
		private function write(level : int, message:String, params : Array):void {
			/*
			var message : String = new String(logMsg);
			var params :Array = new Array(pArray.length);
			
			for (var i:int = 0; i<pArray.length;i++){
				params[i] = pArray[i];
			}
			*/
			if (params)
            var msg :String = StringUtil.substitute(message, params);

            testEvent.message = msg;
	        writeLog.Logger(testTarget, testCategory, level, msg, params); 
			
		}
		
		private function delay():void {
			var i:int = 0;
			
			while (i<100000){
				i++;
			}
		}
	   /**
	     *  Gets the single instance of the XenosLogImpl class.
	     *  This object manages all log resources for a Flex application.
	     *  
	     *  @return An object implementing ILogger.
	     */
	    public static function getInstance():XenosLogImpl
	    {
	        if (!instance)
	            instance = new XenosLogImpl();	

	        return instance;
	    }
	    /**
	     *  Return the concrete implemenation of the log class.
	     */
	    public static function getLog(className:String):XenosLogImpl {
	    	var xLog :XenosLogImpl = getInstance();
	    	xLog.testCategory = className;
	    	return xLog;
	    }
			
	}
}