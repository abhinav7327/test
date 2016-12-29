
package com.nri.rui.core.containers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.controls.XenosHTTPService;
	import com.nri.rui.core.startup.XenosApplication;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import flexlib.mdi.containers.MDIWindow;
	import flexlib.mdi.events.MDIWindowEvent;
	
	import mx.core.Application;
	import mx.rpc.http.HTTPService;

	public class XenosMDIWindow extends MDIWindow
	{
		public var uniqueId:String = Math.random().toString();
		[Bindable]
        public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
        
        private var _menuKeyStr:String;
        
        /**
        * 
        */ 
        public function get menuKeyStr():String{
        	return _menuKeyStr;
        }
        
        /**
        * 
        */ 
        public function set menuKeyStr(key:String):void{
        	_menuKeyStr = key;
        }
        
        [Bindable]
        private var sessionOutService:HTTPService = new XenosHTTPService();
		public function XenosMDIWindow()
		{
			super();
			addEventListener(KeyboardEvent.KEY_DOWN,submitOnEnter);
			addEventListener(MDIWindowEvent.FOCUS_START,setWindowInstance);
			addEventListener(MDIWindowEvent.MAXIMIZE,setWindowInstance);
			addEventListener(MDIWindowEvent.RESTORE,setWindowInstance);
			//t.addEventListener(TimerEvent.TIMER_COMPLETE,sessionOutFunction);
			addEventListener("SomeEvent",sessionOutFunction);
			addEventListener(MDIWindowEvent.CLOSE,closeMDIWin);
		}
		
		/**
		 * This function is used to attach ENTER key with the Submit button
		 * 
		 */ 
		private function submitOnEnter(event:KeyboardEvent){
			//t.stop();
			if(event.keyCode == Keyboard.ENTER){
				if(app.submitButtonInstance)			
					app.submitButtonInstance.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			//t.start();
			}
		
		/**
		 * This function is used to set the MDIWindow instance to a global application variable.
		 * This instance is used to determine the active window instance 
		 */ 	
		private function setWindowInstance(event:MDIWindowEvent):void{
			app.mdiWindowInstance = this;
			Application.application.mdiCanvas.window = XenosMDIWindow(event.currentTarget);
		}
		
		private function sessionOutFunction(event:Event):void{
			/* sessionOutService.url = "";
			sessionOutService.send(); */
			XenosAlert.info("Error occured !!");
		}
		private function closeMDIWin(event:Event):void{
			//remove references and event listeners
			app.submitButtonInstance=null;
            app.mdiWindowInstance=null;   
            removeEventListener(KeyboardEvent.KEY_DOWN,submitOnEnter);
			removeEventListener(MDIWindowEvent.FOCUS_START,setWindowInstance);
			removeEventListener(MDIWindowEvent.MAXIMIZE,setWindowInstance);
			removeEventListener(MDIWindowEvent.RESTORE,setWindowInstance);			
			removeEventListener("SomeEvent",sessionOutFunction);
			removeEventListener(MDIWindowEvent.CLOSE,closeMDIWin);			
		}
		
	}
}