// ActionScript file



package com.nri.rui.core.controls
{
	import mx.rpc.events.ResultEvent;
	import flash.events.Event;
	
	public class XenosHTTPServiceForSpring extends XenosHTTPService {
		// The Command Form Id
		[Bindable]
		private var _commandFormId : String = "" ;
		
		/**
		 * The Default Constructor
		 */ 
		public function XenosHTTPServiceForSpring() {
			super();
		}
		
		/**
		 * The getter of Command Form Id
		 */
		 
		public function get commandFormId () : String {
			return _commandFormId ;
		}
		/**
		 * The setter of Command Form Id
		 */
		public function set commandFormId (cfi : String) : void {
			//XenosAlert.info("7 : " + commandFormId);
			//if (_commandFormId != cfi) {
			//	XenosAlert.info("8");
				_commandFormId = cfi ;
			//	dispatchEvent(new Event("dataChanged"));
			//}
		}
		
		override protected function addDummyParam():void {
			super.addDummyParam();
			if(url.indexOf("commandFormId=")==-1) {
				if(url.indexOf("?")==-1) {
					url=url+"?commandFormId=" + commandFormId;
				} else {
					url=url+"&commandFormId=" + commandFormId;					
				}
			}
		}
		
		public static function getXmlResult(event:ResultEvent) : XML { 
			var result:XML = XML(event.result);

			var resultObj:Object = result;	
			if (result.child("rows").length() > 0 ) {
				var rs:XML = XML(resultObj.rows);

				var prev:XML = XML(resultObj.prevTraversable);

				var next:XML = XML(resultObj.nextTraversable) ;

				rs.appendChild(prev);
				rs.appendChild(next);
				return rs;
			} else  {
				return result;
			}	
		}
		
		override protected function resultHandler(event:ResultEvent):void{
			super.resultHandler(event);
			if(this.resultFormat == "e4x"){				
				if(event.result.hasOwnProperty("commandFormId")) {
					commandFormId = event.result.commandFormId ;
				} else if(event.result.hasOwnProperty("rows")) {
					if(event.result.rows!=null && event.result.rows.hasOwnProperty("commandFormId")) {
						commandFormId = event.result.rows.commandFormId ;
					}
				}
			} else if(this.resultFormat == "xml"){		
				var rs:XML = XML(event.result);				
				/* if(rs.name()=="html") {							
					if(rs.child("head").length()>0)
					{
						var head:XML = XML(rs.head);
						if(head.child("title").length()>0)
						{
							if(head.title=="Welcome To Xenos Login"){				    	
								event.stopImmediatePropagation();
								XenosAlert.info("Session has expired",closeHandler);	
							}
						}
						
					}	
				} */
				//check limitExceeded for max no. of viewable records
				/* else if(rs.limitExceeded=="true")
				{
					XenosAlert.info("Query result is truncated as it exceeds the maximum permissible limit.");
				} */	
				
				if (rs.hasOwnProperty("commandFormId")) {
					commandFormId = rs.commandFormId ;
				}		
				
			}					
			/* else if(event.result.hasOwnProperty("html"))
			{ 
				if(event.result.html){
				//XenosAlert.info("Login :: "+event.result.html.head.title);
				    if(event.result.html.head.title == "Welcome To Xenos Login"){				    	
						event.stopImmediatePropagation();
						XenosAlert.info("Session has expired",closeHandler);					
				    }
			    }
		  	} */
		  	//check limitExceeded for max no. of viewable records
			else if(event.result.hasOwnProperty("rows"))
			{
				if(event.result.rows!=null && event.result.rows.hasOwnProperty("commandFormId"))
				{
					commandFormId = event.result.rows.commandFormId ;
					/* if(String(event.result.rows.limitExceeded)=="true")
					{						
						XenosAlert.info("Query result is truncated as it exceeds the maximum permissible limit.");
					} */
				}
			}
		}

	}
}