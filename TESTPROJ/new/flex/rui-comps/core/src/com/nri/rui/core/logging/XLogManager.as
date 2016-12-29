/*
 *
 *
 *$Author: sutanuc $
*/



package com.nri.rui.core.logging
{
	
	import mx.core.mx_internal;
	import mx.logging.ILogger;
	import mx.logging.ILoggingTarget;
	import mx.logging.Log;
	import mx.logging.LogEvent;
	import mx.logging.targets.LineFormattedTarget;
	import mx.logging.targets.MiniDebugTarget;
	import mx.logging.targets.TraceTarget;
    
    use namespace mx_internal;
	/**
	 *  Xenos Log Manager
	 */
	public class XLogManager
	{
		[Bindable]
		private var logTarget:ILoggingTarget = null;
		
		public function XLogManager()
		{
		}
        
        /**
         * The concrete Logger interface.
         * @target the name of the log target
         * @category The category of the log
         * @level The log level
         * @message The message which will be written into the log file
         * @parameters  optional arguments which will be passed to include in the message
         *  
         */
        
        public function Logger(target:String, category:String, level: int, message:String, ... parameters):void 
        {
            
	         if (logTarget == null) {
	             switch(target) 
	                { 
	                     case 'Line': 
	                        logTarget = new LineFormattedTarget();
	                        break; 
	                     case 'MiniDebug': 
	                         logTarget = new MiniDebugTarget();
	                        break; 
	                     case 'HttpService': 
	                         logTarget = new LogHttpServiceTarget();
	                        break; 
	                     //Trace will be default
	                     case 'Trace':
	                         logTarget = new TraceTarget();                         
	                        break; 
	                     default: 
	                         logTarget = new TraceTarget();
	                        break; 
	                } 
	            
	            Log.addTarget(logTarget);
	         }
                
            var xLogger:ILogger = Log.getLogger(category);
            logTarget.level = level;            
            //Filter target on specific categories.
            logTarget.filters = [category];
            //myTarget.addLogger(myLogger);
            writeLog(xLogger,level,message,parameters);
            //Log.removeTarget(logTarget);           
        }
        /**
         * Write the log information
         * @logger The instance of ILogger interface
         * @level The log level
         * @message The message which will be written into the log file
         * @rest The optional arguments which will be passed to include in the message
         */
        public function writeLog(logger:ILogger, level: int, message:String, ... rest ) : void {
        	
        	//handle the log level
            //It seems that the default behaviour is to log the selected level and those below. For my test I didn’t want that so I simply limited it.
            switch(level)
            {
                case 0:
                    logger.log(level, message, rest);
                    break;
                case 2:
                    if (Log.isDebug()) {
                        logger.debug(message, rest);
                    }
                    break;
                case 4:
                    if (Log.isInfo()) {
                        logger.info(message, rest);
                    }
                    break;
                case 6:
                    if (Log.isWarn()) {
                        logger.warn(message, rest);
                    }
                    break;
                case 8:
                    if (Log.isError()) {
                        logger.error(message, rest);
                    }
                    break;
                case 1000:
                    if (Log.isFatal()) {
                        logger.fatal(message, rest);
                    }
                    break;
            } 
        	
        }

	}
}