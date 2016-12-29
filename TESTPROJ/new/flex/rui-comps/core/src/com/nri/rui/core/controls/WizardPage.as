package com.nri.rui.core.controls
{
	import mx.containers.VBox;
	import mx.events.ValidationResultEvent;
	
	/**
	 * This class is the base class of all the child tab which are implemented using Wizard Control
	 */
	public class WizardPage extends VBox
	{
		private var _response:XML = new XML();
		
		private var _shortTitle:String = "";
		
		private var _longTitle:String = "";
		
		private var _childName:String = "";
		
		private var _mode:String = "entry";
		/**
		 * The boolean value that decide whether the Submit button will be enabled or not
		 */ 
		private var _enableSave:Boolean = true;
		
		public function WizardPage()
		{
			super();
		}
		
		/**
		 * Return the Request object that contain the POST entry/amend data
		 * This method must be implemented in child class
		 */ 
		public virtual function  populateRequest():Object{
			return null;	
		} 
		
		public function get mode():String{
			return _mode;
		}
		
		public function set mode(modestr:String):void{
			_mode=modestr;
		}
		/**
		 * Populate the form with response data
		 * This method must be implemented in child class
		 */ 
		public virtual function  initPage(responseObj:XML):void{
		} 
		
		/**
		 * Return the Client side validation result
		 * This method must be implemented in child class using their own validator
		 */ 
		public virtual function  validate():ValidationResultEvent{
			return null;
		}
		
		public virtual function reset():void {
			
		}
		
		/**
		 * This method is used to change the state of the controls of the page
		 * Individual page(child class) can override this method
		 */ 
		public function  controlStateChangeHandler():void{
		} 
		
		public function  get response():XML{
			return _response;
		} 
		
		public function  set response(responseObj:XML):void{
			_response = responseObj;
		} 
		
		public function  get shortTitle():String{
			return _shortTitle;
		} 
		
		public function  set shortTitle(shrtTitle:String):void{
			_shortTitle = shrtTitle;
		} 
		
		public function  get longTitle():String{
			return _longTitle;
		} 
		
		public function  set longTitle(longTitleStr:String):void{
			_longTitle = longTitleStr;
		} 
		
		public function  get childName():String{
			return _childName;
		} 
		
		public function  set childName(childNameStr:String):void{
			_childName = childNameStr;
		} 
		
		public function  get enableSave():Boolean{
			return _enableSave;
		} 
		
		public function  set enableSave(enableSaveFlag:Boolean):void{
			_enableSave = enableSaveFlag;
		} 
	}
}