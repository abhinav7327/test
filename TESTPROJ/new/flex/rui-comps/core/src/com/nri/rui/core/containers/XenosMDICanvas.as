
package com.nri.rui.core.containers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.controls.MenuPanel;
	import com.nri.rui.core.controls.ModulePanelLoader;
	import com.nri.rui.core.startup.XenosApplication;
	
	import flash.events.MouseEvent;
	
	import flexlib.mdi.containers.MDICanvas;
	import flexlib.mdi.effects.effectsLib.MDIVistaEffects;
	
	public class XenosMDICanvas extends MDICanvas
	{
		public var uniqueWindowIds:Object = new Object();
		private var _window:XenosMDIWindow;
		
		[Embed(source="../../../../../assets/titleIcon.png")]
		private static var TITLE_ICON:Class;
		public function XenosMDICanvas()
		{
			super();
			this.effectsLib = MDIVistaEffects as Class;
		}
		
		public function getwindowKey():String{
			if(window != null)
				return window.menuKeyStr;
			else
				return "unintialized";
		}
		
		public function get window():XenosMDIWindow{
			return _window;
		}
		
		public function set window(curWin:XenosMDIWindow):void{
			_window = curWin;
		}
		
		public function addWindow(uniqueId:String,title:String="Window",winClass:Class=null,url:String=null,menuPk:String = null):void
		{
			//Check whether this window has already been opened
			var created:Boolean = false; 
			var xApp :XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
			minimizeAll();
			if(xApp.multiWindowsOpen == false){
				created = checkWindowCreation(uniqueId);
				if(created == true){
				//if(window.savedWindowRect != null){
				if(window.minimized == true) {
					window.unMinimize(new MouseEvent(MouseEvent.CLICK));
					this.windowManager.bringToFront(window);
					return;
				}else {
					//window.restore();
					this.windowManager.bringToFront(window);
					return;
				}
			  }
			}
			
			var win:XenosMDIWindow ;
			if(winClass == null){
			 	win = new XenosMDIWindow();
			}else {
				win = new winClass();
				if ( win is ModulePanelLoader){
					ModulePanelLoader(win).url = url; 
					
				}
			}
			//win.width = 500 ;
			win.title = title;
			win.menuKeyStr = menuPk;
			if(!xApp.multiWindowsOpen  || (win is MenuPanel)){
				win.uniqueId = uniqueId;
			}
			win.titleIcon = TITLE_ICON;
			window = win;
			this.windowManager.add(win);
			if( !(win is MenuPanel)){
				//Measure and position the Window
				var menu : XenosMDIWindow = getMenuWindow("navigation");
				if(menu != null){ //when window is opend from Vertical Menu
					win.x = (xApp.winX+10 >= this.width) ? this.x : xApp.winX +3;
					win.y = xApp.winY >= this.height ? this.y : xApp.winY ;
					win.width = this.width - win.x ;					
				}else{ //when window is opend from Horizontal Menu				    
				    win.x = this.x;
				    win.y = this.y;
				    win.width = this.width - win.x - 6 ; // 6 for showing the right side border properly.				    
				}
			}
			//win.height = this.height - 40;
			win.percentHeight = 94;
			
		}
		
		
		private function minimizeAll():void {
			var openwindows : Array = this.windowManager.getOpenWindowList();
			for(var i:int = 0; i<openwindows.length;i++){
				var tempWin:XenosMDIWindow = XenosMDIWindow(openwindows[i]);
				if(tempWin.uniqueId != 'navigation'){
					tempWin.minimize(new MouseEvent(MouseEvent.CLICK));
				}
			}
		}
		private function getMenuWindow(uniqueId:String):XenosMDIWindow
		{
			var availablewindows : Array = this.windowManager.windowList;
			for(var i:int = 0; i<availablewindows.length;i++){
				var tempWin:XenosMDIWindow = XenosMDIWindow(availablewindows[i]);
				if(tempWin.uniqueId == uniqueId){
					//window = tempWin;
					return tempWin;
				}
			}
			return null;
		}
		//Return true if this window is already created
		// and false if a new Window has to be opened.
		private function checkWindowCreation(uniqueId:String):Boolean
		{
			var availablewindows : Array = this.windowManager.windowList;
			for(var i:int = 0; i<availablewindows.length;i++){
				var tempWin:XenosMDIWindow = XenosMDIWindow(availablewindows[i]);
				if(tempWin.uniqueId == uniqueId){
					window = tempWin;
					return true;
				}
			}
			return false;
		}
	}
}