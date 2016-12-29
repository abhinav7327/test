package com.nri.rui.core.controls
{
	import flash.events.Event;

	public class CustomChangeEvent extends Event
	{
		private var _targetParams:Object;
		
		private var _targetInstance:Object;
		
		public function CustomChangeEvent(type:String, param:Object=null, targetInst:Object=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			targetParams = param;
			targetInstance = targetInst;
		}
		
		public function get targetParams():Object {
            return _targetParams;
        }
        
        public function set targetParams(paramObj:Object):void {
            _targetParams = paramObj;
        }
        
        public function get targetInstance():Object {
            return _targetInstance;
        }
        
        public function set targetInstance(targetObj:Object):void {
            _targetInstance = targetObj;
        }
		
	}
}