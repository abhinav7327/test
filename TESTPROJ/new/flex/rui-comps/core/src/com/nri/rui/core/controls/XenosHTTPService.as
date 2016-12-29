// ActionScript file



package com.nri.rui.core.controls{
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.messaging.messages.HTTPRequestMessage;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	
	
	public class XenosHTTPService extends HTTPService{
		
		private var backupURL:String="";
		
		//Constructor
		public function XenosHTTPService(){
			super();
			
			//addEventListener(FaultEvent.FAULT,faultHandler);
			method = HTTPRequestMessage.POST_METHOD
			showBusyCursor = true;
		}
		
		//override default send method to handle caching problems. Adding a dummy request parameter
		override public function send(parameters:Object = null):AsyncToken
		{
			
			/* if(!request.hasOwnProperty("unique"))
			{
				request.unique=new Date().getTime();
			} */			
			if (Application.application.hasOwnProperty("mdiCanvas") 
							&& Application.application.mdiCanvas != null) {
				trace("Application:: " + Application.application.mdiCanvas.getwindowKey());
				//XenosAlert.info("Application:: "+Application.application.mdiCanvas.getwindowKey());
				var reqObj:Object = this.request;				
				reqObj.menuPk = XenosStringUtils.equals(Application.application.mdiCanvas.getwindowKey(),"unintialized") ? XenosStringUtils.EMPTY_STR : Application.application.mdiCanvas.getwindowKey();
				/*if(reqObj.menuPk=="unintialized")
					reqObj.menuPk = "";*/
				this.request = reqObj;
				//XenosAlert.info("Menu Pk has been set.");
			} else {
				//XenosAlert.info("Could not set menu pk.");
				trace("MDI Canvas of the current Application not found! Couldn't set Menu Pk");
			}
			addEventListener(ResultEvent.RESULT,resultHandler,false,100);
			backupURL=url;
			addDummyParam();
			return (super.send(parameters));
		}
		//Default Result handler
		protected function resultHandler(event:ResultEvent):void{	
			url=backupURL;
			backupURL=null;				
			if(this.resultFormat == "e4x"){				
				if(event.result.hasOwnProperty("head"))
				{
					if(event.result.head.title == "Welcome To Xenos Login"){						
						event.stopImmediatePropagation();					
						XenosAlert.info("Session has expired",closeHandler);						
				 	}
				}
				//check limitExceeded for max no. of viewable records
				else if(event.result.hasOwnProperty("rows"))
				{
					if(event.result.rows!=null && event.result.rows.hasOwnProperty("limitExceeded"))
					{
						if(event.result.rows.limitExceeded=="true")
						{
							XenosAlert.info("Query result is truncated as it exceeds the maximum permissible limit.");
						}
					}
				}
			}
			else if(this.resultFormat == "xml"){				
				var rs:XML = XML(event.result);				
				if(rs.name()=="html")
				{							
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
				}
				//check limitExceeded for max no. of viewable records
				else if(rs.limitExceeded=="true")
				{
					XenosAlert.info("Query result is truncated as it exceeds the maximum permissible limit.");
				}			
				
			}					
			else if(event.result.hasOwnProperty("html"))
			{ 
				if(event.result.html){
				//XenosAlert.info("Login :: "+event.result.html.head.title);
				    if(event.result.html.head.title == "Welcome To Xenos Login"){				    	
						event.stopImmediatePropagation();
						XenosAlert.info("Session has expired",closeHandler);					
				    }
			    }
		  	}
		  	//check limitExceeded for max no. of viewable records
			else if(event.result.hasOwnProperty("rows"))
			{
				if(event.result.rows!=null && event.result.rows.hasOwnProperty("limitExceeded"))
				{
					if(String(event.result.rows.limitExceeded)=="true")
					{						
						XenosAlert.info("Query result is truncated as it exceeds the maximum permissible limit.");
					}
				}
			}
			
			removeEventListener(ResultEvent.RESULT,resultHandler);
		}
		//Default Fault handler
		 private function faultHandler(event:FaultEvent){
			XenosAlert.info("faultHandler");
			dispatchEvent(new Event("sessionOut",true));
		}
		
		 //Default alert close handler
		 private function closeHandler(event:CloseEvent):void {
			var url : String = "main.action?unique="+new Date().getTime();
			var request:URLRequest = new URLRequest(url);
			request.method = "POST";
			 try {
			         navigateToURL(request,"_self");
			      }
			 catch (e:Error) {
			      // handle error here
			      trace(e);
			    }
		}
		
		//method to add dummy paramter to query string to prevent caching
		protected function addDummyParam():void
		{
			if(url.indexOf("unique=")==-1)
			{
				if(url.indexOf("?")==-1)
				{
					url=url+"?unique="+new Date().getTime();
				}
				else
				{
					//var queryString:String=url.substring(url.indexOf("?")+1);
					url=url+"&unique="+new Date().getTime();					
				}
			}
			
		}
		
		
	}
}
