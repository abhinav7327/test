
 
package com.nri.rui.core.controls
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.startup.XenosApplication;
	
	import flexlib.mdi.events.MDIWindowEvent;
	
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	public class XenosButton extends Button{
		[Bindable]
        public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
		
		[Bindable]
		public var obj:XenosButton;
		
		public function XenosButton(){
			
			super();
			if(app.mdiWindowInstance){
				app.mdiWindowInstance.addEventListener(MDIWindowEvent.FOCUS_START,setActiveSubmitBtn);
				app.mdiWindowInstance.addEventListener(MDIWindowEvent.MAXIMIZE,setActiveSubmitBtn);
				app.mdiWindowInstance.addEventListener(MDIWindowEvent.RESTORE,setActiveSubmitBtn);
			}
			app.submitButtonInstance = this;
			obj = this;
			
		}
		
		/**
		 * This function is used to store the default active button in a variable
		 * at the Application level
		 */ 
		public function setActiveSubmitBtn(event: MDIWindowEvent) : void{
            app.submitButtonInstance = obj;
        }
        
        /* public function setSubmitBtn(event: FlexEvent) : void{
        	XenosAlert.info("Enter State");
            app.submitButtonInstance = obj;
        }
        
        public function removeSubmitBtn(event: FlexEvent) : void{
        	XenosAlert.info("Exit State");
            app.submitButtonInstance = null;
        } */
		
	}
}